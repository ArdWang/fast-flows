/// Fast Flows Test Suite
///
/// This file runs all tests for the Fast Flows framework
library;

import 'package:flutter_test/flutter_test.dart';

import 'core/flows_test.dart' as flows_test;
import 'core/lifecycle_test.dart' as lifecycle_test;
import 'rx/rx_types_test.dart' as rx_types_test;
import 'rx/rx_list_test.dart' as rx_list_test;
import 'rx/rx_map_test.dart' as rx_map_test;
import 'state_manager/flows_controller_test.dart' as flows_controller_test;
import 'state_manager/flx_test.dart' as flx_test;
import 'navigation/flows_page_test.dart' as flows_page_test;

void main() {
  group('Fast Flows Core Tests', () {
    flows_test.main();
    lifecycle_test.main();
  });

  group('Fast Flows RX Tests', () {
    rx_types_test.main();
    rx_list_test.main();
    rx_map_test.main();
  });

  group('Fast Flows State Manager Tests', () {
    flows_controller_test.main();
    flx_test.main();
  });

  group('Fast Flows Navigation Tests', () {
    flows_page_test.main();
  });
}
