import 'package:dynamic_form/_libraries/_interfaces/data_model.dart';

import 'form_field_model.dart';

class FormModel implements DataModel {
  const FormModel({
    required this.formName,
    required this.fields,
  });

  final String formName;
  final List<FormFieldModel> fields;

  @override
  Map<String, dynamic> toMap() {
    return {
      'form_name': formName,
      'fields': fields.map((x) => x.toMap()).toList(),
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
      formName: map['form_name'] ?? '',
      fields: List<FormFieldModel>.from(
          map['fields']?.map((x) => FormFieldModel.fromMap(x))),
    );
  }
}
