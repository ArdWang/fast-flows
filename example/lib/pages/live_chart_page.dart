/// Live Chart Page - Real-time temperature monitoring
///
/// Displays a real-time line chart that updates every 5 seconds
/// with random temperature data. Demonstrates:
/// - Timer-based data updates
/// - fl_chart line chart visualization
/// - Dynamic data management with Fast Flows Rx
library;

import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart' hide Flow;
import 'package:fast_flows/flows.dart';
import 'package:fl_chart/fl_chart.dart' as fl;

import '../main.dart' show AppColors;
import '../utils/pretty_print.dart';

/// Data point for the chart
class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData({
    required this.time,
    required this.temperature,
  });

  /// Format time as HH:mm:ss
  String get formattedTime =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}:'
      '${time.second.toString().padLeft(2, '0')}';
}

/// State for the live chart page
class LiveChartState {
  final List<TemperatureData> _dataPoints = [];
  Timer? _updateTimer;
  final Random _random = Random();

  /// Maximum number of data points to display
  final int maxDataPoints = 20;

  /// Rx variable to trigger UI updates
  final refreshFlag = false.obs;

  /// Generate random temperature between 15-35°C
  double _generateRandomTemperature() {
    return 15 + _random.nextDouble() * 20;
  }

  /// Add a new data point
  void _addDataPoint() {
    final now = DateTime.now();
    final temp = _generateRandomTemperature();

    _dataPoints.add(TemperatureData(time: now, temperature: temp));

    // Keep only the latest N data points
    if (_dataPoints.length > maxDataPoints) {
      _dataPoints.removeAt(0);
    }

    // Trigger UI update
    refreshFlag.value = !refreshFlag.value;

    PrettyLogger.info(
      'Added data point: ${_dataPoints.last.formattedTime} - ${temp.toStringAsFixed(1)}°C'
      ' (Total: ${_dataPoints.length})'
    );
  }

  /// Start the auto-update timer
  void startAutoUpdate() {
    if (_updateTimer != null) return;

    PrettyLogger.success('Starting auto-update timer (5s interval)...');

    // Add initial data point
    _addDataPoint();

    // Update every 5 seconds
    _updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _addDataPoint(),
    );
  }

  /// Stop the auto-update timer
  void stopAutoUpdate() {
    PrettyLogger.info('Stopping auto-update timer...');
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  /// Clear all data points
  void clearData() {
    _dataPoints.clear();
    refreshFlag.value = !refreshFlag.value;
    PrettyLogger.info('Data cleared');
  }

  /// Get current data points
  List<TemperatureData> get dataPoints => List.unmodifiable(_dataPoints);

  /// Get latest temperature
  double? get latestTemperature =>
      _dataPoints.isNotEmpty ? _dataPoints.last.temperature : null;

  /// Get min temperature
  double? get minTemperature {
    if (_dataPoints.isEmpty) return null;
    return _dataPoints.map((d) => d.temperature).reduce(min);
  }

  /// Get max temperature
  double? get maxTemperature {
    if (_dataPoints.isEmpty) return null;
    return _dataPoints.map((d) => d.temperature).reduce(max);
  }

  /// Get average temperature
  double? get averageTemperature {
    if (_dataPoints.isEmpty) return null;
    final sum = _dataPoints.map((d) => d.temperature).reduce((a, b) => a + b);
    return sum / _dataPoints.length;
  }

  void dispose() {
    stopAutoUpdate();
  }
}

/// Logic for the live chart page
class LiveChartLogic extends FlowController {
  final state = LiveChartState();

  void startAutoUpdate() => state.startAutoUpdate();
  void stopAutoUpdate() => state.stopAutoUpdate();
  void clearData() => state.clearData();

  @override
  void onClose() {
    state.dispose();
    super.onClose();
  }
}

/// Live Chart Page Widget
class LiveChartPage extends StatefulWidget {
  const LiveChartPage({super.key});

  @override
  State<LiveChartPage> createState() => _LiveChartPageState();
}

class _LiveChartPageState extends State<LiveChartPage> {
  late final LiveChartLogic _logic;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();
    _logic = Flow.put(LiveChartLogic());
    _logic.startAutoUpdate();
  }

  @override
  void dispose() {
    _logic.stopAutoUpdate();
    super.dispose();
  }

  /// Calculate number of bottom titles based on screen width
  int _calculateBottomTitlesCount(double screenWidth) {
    if (screenWidth < 400) {
      return 5; // Mobile: 5 titles
    } else if (screenWidth < 600) {
      return 7; // Tablet: 7 titles
    } else {
      return 10; // Desktop/Wide: 10 titles
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Temperature Monitor'),
        actions: [
          // Stop button
          IconButton(
            icon: const Icon(Icons.pause),
            tooltip: 'Pause',
            onPressed: () => _logic.stopAutoUpdate(),
          ),
          // Start button
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Resume',
            onPressed: () => _logic.startAutoUpdate(),
          ),
          // Clear button
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear',
            onPressed: () => _logic.clearData(),
          ),
        ],
      ),
      body: Flx(() {
        // Access refreshFlag to trigger rebuild on data change
        _logic.state.refreshFlag.value;

        final dataPoints = _logic.state.dataPoints;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Statistics cards
              _buildStatsCards(_logic.state),

              const SizedBox(height: 24),

              // Chart title
              const Text(
                'Temperature Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Line chart
              _buildLineChart(dataPoints),

              const SizedBox(height: 24),

              // Data table
              _buildDataTable(dataPoints),

              const SizedBox(height: 16),

              // Info text
              Text(
                'Updates every 5 seconds · Shows up to ${_logic.state.maxDataPoints} data points',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build statistics cards
  Widget _buildStatsCards(LiveChartState state) {
    final latest = state.latestTemperature;
    final min = state.minTemperature;
    final max = state.maxTemperature;
    final avg = state.averageTemperature;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildStatCard(
          'Current',
          latest != null ? '${latest.toStringAsFixed(1)}°C' : '-',
          Icons.waves,
          AppColors.primary,
        ),
        _buildStatCard(
          'Min',
          min != null ? '${min.toStringAsFixed(1)}°C' : '-',
          Icons.arrow_downward,
          AppColors.success,
        ),
        _buildStatCard(
          'Max',
          max != null ? '${max.toStringAsFixed(1)}°C' : '-',
          Icons.arrow_upward,
          AppColors.warning,
        ),
        _buildStatCard(
          'Average',
          avg != null ? '${avg.toStringAsFixed(1)}°C' : '-',
          Icons.show_chart,
          AppColors.accent,
        ),
      ],
    );
  }

  /// Build a single stat card
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the line chart
  Widget _buildLineChart(List<TemperatureData> dataPoints) {
    if (dataPoints.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_graph, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Waiting for data...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final titlesCount = _calculateBottomTitlesCount(_screenWidth);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: fl.LineChart(
        fl.LineChartData(
          gridData: const fl.FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: 5,
          ),
          titlesData: fl.FlTitlesData(
            show: true,
            leftTitles: fl.AxisTitles(
              sideTitles: fl.SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}°',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: fl.AxisTitles(
              sideTitles: fl.SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: dataPoints.length <= titlesCount
                    ? 1
                    : (dataPoints.length / titlesCount).ceil().toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < dataPoints.length) {
                    return Text(
                      dataPoints[index].formattedTime,
                      style: const TextStyle(fontSize: 8),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles: const fl.AxisTitles(
              sideTitles: fl.SideTitles(showTitles: false),
            ),
            rightTitles: const fl.AxisTitles(
              sideTitles: fl.SideTitles(showTitles: false),
            ),
          ),
          borderData: fl.FlBorderData(show: false),
          lineBarsData: [
            fl.LineChartBarData(
              spots: dataPoints
                  .asMap()
                  .entries
                  .map((e) => fl.FlSpot(e.key.toDouble(), e.value.temperature))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.2,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: fl.FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return fl.FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: AppColors.primary,
                  );
                },
              ),
              belowBarData: fl.BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
          minY: 10,
          maxY: 40,
          lineTouchData: fl.LineTouchData(
            enabled: true,
            touchTooltipData: fl.LineTouchTooltipData(
              getTooltipColor: (spot) => AppColors.primaryDark,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final dataPoint = dataPoints[spot.x.toInt()];
                  return fl.LineTooltipItem(
                    '${dataPoint.formattedTime}\n${spot.y.toStringAsFixed(1)}°C',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Build data table
  Widget _buildDataTable(List<TemperatureData> dataPoints) {
    if (dataPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Temp (°C)')),
          ],
          rows: dataPoints.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(Text(data.formattedTime)),
                DataCell(Text(data.temperature.toStringAsFixed(1))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
