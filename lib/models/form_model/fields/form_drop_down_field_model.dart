import '../form_field_model.dart';

class FormDropDownFieldModel extends FormMultiSelectionFieldModel {
  const FormDropDownFieldModel({
    required super.label,
    required super.options,
    required super.mandatory,
  });

  @override
  String get componentType => "DropDown";

  factory FormDropDownFieldModel.fromMap(Map<String, dynamic> map) {
    map = FormMultiSelectionFieldModel.mapped(map);
    return FormDropDownFieldModel(
      label: map['label'],
      options: map['options'],
      mandatory: map['mandatory'],
    );
  }
}
