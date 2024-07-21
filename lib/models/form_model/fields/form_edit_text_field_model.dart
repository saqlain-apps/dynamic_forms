import '../form_field_model.dart';

enum EditTextFieldInputType {
  integer,
  text;

  String get apiKey => name.toUpperCase();
  static EditTextFieldInputType parse(String value) =>
      EditTextFieldInputType.values.firstWhere((e) => e.apiKey == value);
}

class FormEditTextFieldModel extends FormFieldModel {
  const FormEditTextFieldModel({
    required this.label,
    required this.inputType,
    required this.mandatory,
  });

  final String label;
  final EditTextFieldInputType inputType;

  @override
  final bool mandatory;

  @override
  String get componentType => "EditText";

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'meta_info': {
        'label': label,
        'component_input_type': inputType.apiKey,
        'mandatory': mandatory,
      },
    };
  }

  factory FormEditTextFieldModel.fromMap(Map<String, dynamic> map) {
    return FormEditTextFieldModel(
      label: map['label'] ?? '',
      inputType: EditTextFieldInputType.parse(map['component_input_type']),
      mandatory: FormFieldModel.isMandatory(map),
    );
  }
}
