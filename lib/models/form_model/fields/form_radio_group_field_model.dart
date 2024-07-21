import '../form_field_model.dart';

class FormRadioGroupFieldModel extends FormMultiSelectionFieldModel {
  const FormRadioGroupFieldModel({
    required super.label,
    required super.options,
    required super.mandatory,
  });

  @override
  String get componentType => "RadioGroup";

  factory FormRadioGroupFieldModel.fromMap(Map<String, dynamic> map) {
    map = FormMultiSelectionFieldModel.mapped(map);
    return FormRadioGroupFieldModel(
      label: map['label'],
      options: map['options'],
      mandatory: map['mandatory'],
    );
  }
}
