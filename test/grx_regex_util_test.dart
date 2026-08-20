import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/utils/grx_regex.util.dart';

void main() {
  group('GrxRegexUtils.initialsFromName', () {
    test('returns empty for null, blank or whitespace', () {
      expect(GrxRegexUtils.initialsFromName(null), '');
      expect(GrxRegexUtils.initialsFromName(''), '');
      expect(GrxRegexUtils.initialsFromName('   '), '');
    });

    test('returns single initial while typing first name', () {
      expect(GrxRegexUtils.initialsFromName('J'), 'J');
      expect(GrxRegexUtils.initialsFromName('Jo'), 'JO');
    });

    test('returns two initials for full name', () {
      expect(GrxRegexUtils.initialsFromName('John Doe'), 'JD');
      expect(GrxRegexUtils.initialsFromName('John D'), 'JD');
    });

    test('ignores trailing space without second word', () {
      expect(GrxRegexUtils.initialsFromName('John '), 'JO');
      expect(GrxRegexUtils.initialsFromName('J '), 'J');
    });
  });
}
