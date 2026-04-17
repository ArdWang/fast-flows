/// Rx Workers - Reactive workers for streams and callbacks
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debounce worker - delays execution until after a pause
class DebounceWorker {
  final Duration duration;
  Timer? _timer;

  DebounceWorker(this.duration);

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Throttle worker - limits execution to once per duration
class ThrottleWorker {
  final Duration duration;
  bool _isThrottled = false;
  VoidCallback? _queuedCallback;
  Timer? _timer;

  ThrottleWorker(this.duration);

  void call(void Function() callback) {
    if (_isThrottled) {
      _queuedCallback = callback;
      return;
    }
    callback();
    _isThrottled = true;
    _timer = Timer(duration, () {
      _isThrottled = false;
      if (_queuedCallback != null) {
        final cb = _queuedCallback;
        _queuedCallback = null;
        cb!();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _queuedCallback = null;
  }
}

/// Creates a debounce worker
DebounceWorker debounce(Duration duration) => DebounceWorker(duration);

/// Creates a throttle worker
ThrottleWorker throttle(Duration duration) => ThrottleWorker(duration);
