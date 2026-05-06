/// FlowApp - Material and Cupertino app widgets with routing
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/flows.dart';
import 'flows_page.dart';

/// FlowsMaterialApp - Material app with Flows routing support
class FlowsMaterialApp extends StatefulWidget {
  /// The home widget
  final Widget? home;

  /// The initial route
  final String? initialRoute;

  /// All pages for the app
  final List<FlowsPage>? pages;

  /// Theme data
  final ThemeData? theme;

  /// Dark theme data
  final ThemeData? darkTheme;

  /// Theme mode - can be a reactive value
  final ThemeMode? themeMode;

  /// Debug banner enabled
  final bool debugShowCheckedModeBanner;

  /// Custom routes
  final Map<String, Widget Function(BuildContext)>? routes;

  /// Unknown route handler
  final Widget Function(BuildContext)? unknownRoute;

  /// Navigator observers
  final List<NavigatorObserver>? navigatorObservers;

  /// Builder for wrapping the entire app
  final Widget Function(BuildContext, Widget?)? builder;

  /// App title for accessibility
  final String? title;

  const FlowsMaterialApp({
    super.key,
    this.home,
    this.initialRoute,
    this.pages,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.debugShowCheckedModeBanner = true,
    this.routes,
    this.unknownRoute,
    this.navigatorObservers,
    this.builder,
    this.title,
  });

  @override
  State<FlowsMaterialApp> createState() => _FlowsMaterialAppState();
}

class _FlowsMaterialAppState extends State<FlowsMaterialApp> {
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.themeMode ?? ThemeMode.system;
  }

  @override
  void didUpdateWidget(FlowsMaterialApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.themeMode != oldWidget.themeMode) {
      setState(() {
        _currentThemeMode = widget.themeMode ?? ThemeMode.system;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build page routes - don't use 'routes' property as it doesn't pass arguments
    final Map<String, WidgetBuilder> builtRoutes = {};
    if (widget.pages != null) {
      for (final page in widget.pages!) {
        builtRoutes[page.name] = (_) => page.page();
      }
    }
    if (widget.routes != null) {
      builtRoutes.addAll(widget.routes!);
    }

    return MaterialApp(
      key: widget.key,
      title: widget.title,
      home: widget.home ?? (widget.pages != null && widget.pages!.isNotEmpty ? widget.pages!.first.page() : null),
      initialRoute: widget.initialRoute,
      // Don't use 'routes' property - it doesn't pass arguments correctly
      // Use onGenerateRoute instead
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: _currentThemeMode,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      navigatorKey: Flows.navigatorKey,
      navigatorObservers: widget.navigatorObservers ?? [],
      builder: widget.builder,
      onGenerateRoute: (settings) {
        // Pass settings (including arguments) to MaterialPageRoute
        if (builtRoutes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: builtRoutes[settings.name]!,
            settings: settings, // Pass settings with arguments
          );
        }
        if (widget.unknownRoute != null) {
          return MaterialPageRoute(
            builder: (_) => widget.unknownRoute!(Flows.navigator!.context),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

/// FlowsCupertinoApp - Cupertino app with Flows routing support
class FlowsCupertinoApp extends StatelessWidget {
  final Widget? home;
  final String? initialRoute;
  final List<FlowsPage>? pages;
  final bool debugShowCheckedModeBanner;
  final Map<String, Widget Function(BuildContext)>? routes;

  const FlowsCupertinoApp({
    super.key,
    this.home,
    this.initialRoute,
    this.pages,
    this.debugShowCheckedModeBanner = true,
    this.routes,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> builtRoutes = {};
    if (pages != null) {
      for (final page in pages!) {
        builtRoutes[page.name] = (_) => page.page();
      }
    }
    if (routes != null) {
      builtRoutes.addAll(routes!);
    }

    return CupertinoApp(
      key: key,
      home: home ?? (pages != null && pages!.isNotEmpty ? pages!.first.page() : null),
      initialRoute: initialRoute,
      routes: builtRoutes,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: Flows.navigatorKey,
    );
  }
}
