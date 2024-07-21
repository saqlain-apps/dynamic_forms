part of '../validation.dart';

class ValidationStrings {
  const ValidationStrings({this.field = "Field"});

  final String field;

  String get improperEmail => 'Please enter valid Email ID';
  String get invalidLengthPassword => 'Please enter at least 8+ characters';
  String get improperPassword =>
      'Please enter a valid password having minimum of 8 characters, an uppercase letter, a lowercase letter, a number, and a special character.';
  String get improperPhone => 'Invalid Mobile No.';
  String get invalidLengthPhone => 'Phone Number must be of 10 digits';
  String get incorrectRepeatPassword =>
      "New Password and Confirm Password doesn't match";
  String get improperName => 'Please enter a valid Name';
  String get emptyField => '$field cannot be Empty';
  String get nullField => '$field is required';
  String get improperDecimal => 'Please Enter a Proper Number';
  String get improperSpaceName => 'Name Cannot contain Empty Spaces';
  String get improperDate => 'Please Enter a Proper in the format dd/mm/yyyy';
  String get invalidLengthPercentage =>
      'Percentage must be less than or Equal to 100';
  String get improperPercentage => 'Please Enter a proper Number';
  String get improperFirstPhone => 'Phone Number must not start with 0';
  String get improperCountryCodeFirst => "Country Code must start with '+'";
  String get improperCountryCode => 'Please enter a proper country code';
  String get improperSingleNumber => 'Please Enter a Proper Number';
  String get invalidLengthSingleNumber => 'Value must be of only 1 digit';
  String get invalidLengthString => '$field cannot be less than 3 Letters';
  String get emptyFirstName => 'Please enter First Name';
  String get invalidFirstName => 'Please enter a valid First Name';
  String get emptyLastName => 'Please enter Last Name';
  String get invalidLastName => 'Please enter a valid Last Name';
  String get emptyPhone => 'Please enter Phone Number';
  String get emptyPassword => 'Please enter a valid password';
}
