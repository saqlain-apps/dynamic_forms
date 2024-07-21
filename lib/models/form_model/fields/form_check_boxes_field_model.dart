import '../form_field_model.dart';

class FormCheckBoxesFieldModel extends FormMultiSelectionFieldModel {
  const FormCheckBoxesFieldModel({
    required super.label,
    required super.options,
    required super.mandatory,
  });

  @override
  String get componentType => "CheckBoxes";

  factory FormCheckBoxesFieldModel.fromMap(Map<String, dynamic> map) {
    map = FormMultiSelectionFieldModel.mapped(map);
    return FormCheckBoxesFieldModel(
      label: map['label'],
      options: map['options'],
      mandatory: map['mandatory'],
    );
  }
}
