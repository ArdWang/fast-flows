/// Pretty Logger - Utility for colorful console output
library;

/// Pretty Logger for formatted console output
class PrettyLogger {
  /// Print a colorful header
  static void header(String message) {
    print('');
    print('╔═══════════════════════════════════════════════════════════╗');
    print('║  $message');
    print('╚═══════════════════════════════════════════════════════════╝');
    print('');
  }

  /// Print an info message
  static void info(String message) {
    print('ℹ️  INFO: $message');
  }

  /// Print a debug message
  static void debug(String message) {
    print('🐛 DEBUG: $message');
  }

  /// Print a success message
  static void success(String message) {
    print('✅ SUCCESS: $message');
  }

  /// Print a warning message
  static void warning(String message) {
    print('⚠️  WARNING: $message');
  }

  /// Print a data message
  static void data(String label, String value) {
    print('📌 $label: $value');
  }

  /// Print a divider with title
  static void divider(String title) {
    print('');
    print('━━━ $title ━━━');
    print('');
  }

  /// Print a box message
  static void box(String message) {
    print('┌─────────────────────────────────────────┐');
    print('│  $message');
    print('└─────────────────────────────────────────┘');
  }

  /// Print a list
  static void list(List<String> items) {
    for (int i = 0; i < items.length; i++) {
      print('  ${i + 1}. ${items[i]}');
    }
  }
}
