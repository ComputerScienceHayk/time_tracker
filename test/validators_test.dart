import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/app/validators.dart';

void main() {
  test('non empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.valid('test'), true);
  });

  test('empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.valid(''), false);
  });

  // test('null string', () {
  //   final validator = NonEmptyStringValidator();
  //   expect(validator.valid(null), false);
  // });
}