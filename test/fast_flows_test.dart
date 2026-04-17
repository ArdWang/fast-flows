/// Fast Flows Test Suite
///
/// This file runs all tests for the Fast Flows framework
library;

import 'package:flutter_test/flutter_test.dart';

import 'core/flow_test.dart' as flow_test;
import 'core/lifecycle_test.dart' as lifecycle_test;
import 'rx/rx_types_test.dart' as rx_types_test;
import 'rx/rx_list_test.dart' as rx_list_test;
import 'rx/rx_map_test.dart' as rx_map_test;
import 'state_manager/flow_controller_test.dart' as flow_controller_test;
import 'state_manager/flx_test.dart' as flx_test;
import 'navigation/flow_page_test.dart' as flow_page_test;

void main() {
  group('Fast Flows Core Tests', () {
    flow_test.main();
    lifecycle_test.main();
  });

  group('Fast Flows RX Tests', () {
    rx_types_test.main();
    rx_list_test.main();
    rx_map_test.main();
  });

  group('Fast Flows State Manager Tests', () {
    flow_controller_test.main();
    flx_test.main();
  });

  group('Fast Flows Navigation Tests', () {
    flow_page_test.main();
  });
}
