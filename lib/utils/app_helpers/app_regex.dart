class AppRegex {
  static RegExp get numberOnlyFilter => RegExp(r'[\d]');
  static RegExp get decimalFilter => RegExp(r'^\d{0,9}(?:\.\d{0,3})?$');
  static RegExp get alphabetOnlyFilter => RegExp(r'[a-zA-Z]');
  static RegExp get alphabetSpaceFilter => RegExp(r'[a-zA-Z ]');
  static RegExp get sentenceFilter => RegExp(r'[a-zA-Z .]');
  static RegExp get dateOnlyFilter => RegExp(r'[\d\/]');

  // Inverse
  static RegExp get inverseNumberOnlyFilter => RegExp(r'[^\d]');
  static RegExp get inverseDecimalFilter => RegExp(r'[^\d.]');
  static RegExp get inverseAlphabetOnlyFilter => RegExp(r'[^a-zA-Z]');
  static RegExp get inverseAlphabetSpaceFilter => RegExp(r'[^a-zA-Z ]');
  static RegExp get invsereSentenceFilter => RegExp(r'[^a-zA-Z .]');
  static RegExp get inverseDateOnlyFilter => RegExp(r'[^\d\/]');
  static RegExp get checkNull => RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])');

  // Whole Matches Only
  static RegExp get email =>
      RegExp(r'^\w+(?:[.-]?\w+)*@\w+(?:[.-]?\w+)*(?:\.\w{2,3})+$');
  static RegExp get password =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static RegExp get passwordWithSpecialChar =>
      RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{12,}$');
  static RegExp get usPhoneFormatChars => RegExp(r'[\(\)\-\s]');
  static RegExp get zeroPlus => RegExp(r'^0+');
  static RegExp get digitOrBracket => RegExp(r'[\d\(]');
}
