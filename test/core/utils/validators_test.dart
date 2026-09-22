import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning/core/utils/validators.dart';

void main() {
  group('Validators Test Suite', () {
    test('email handles valid emails', () {
      expect(Validators.email('student@edulearn.com'), isNull);
      expect(Validators.email('test.user@domain.com'), isNull);
    });

    test('email rejects invalid emails', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('missing@domain'), isNotNull);
    });

    test('password requires at least 6 characters', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('password123'), isNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('requiredField rejects empty strings and nulls', () {
      expect(Validators.requiredField('Valid Text', 'Name'), isNull);
      expect(Validators.requiredField('', 'Name'), 'Name is required');
      expect(Validators.requiredField('   ', 'Name'), 'Name is required');
      expect(Validators.requiredField(null, 'Name'), 'Name is required');
    });

    test('confirmPassword checks match', () {
      expect(Validators.confirmPassword('pass123', 'pass123'), isNull);
      expect(Validators.confirmPassword('pass123', 'different'), 'Passwords do not match');
    });
  });
}
