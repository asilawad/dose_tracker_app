import 'package:dose_tracker/core/utils/avatar_initial.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the first character of a trimmed name', () {
    expect(AvatarInitial.of('Mama'), 'M');
    expect(AvatarInitial.of('يوسف'), 'ي');
    expect(AvatarInitial.of('  sara'), 'S');
  });

  test('uses a question mark for an empty or blank name', () {
    expect(AvatarInitial.of(''), '?');
    expect(AvatarInitial.of('   '), '?');
  });
}
