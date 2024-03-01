import 'package:flutter_test/flutter_test.dart';
import 'package:bingo_app/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CardsViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
