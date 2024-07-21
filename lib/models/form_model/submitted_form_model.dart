import 'package:dynamic_form/_libraries/_interfaces/data_model.dart';

import 'form_field_model.dart';

class SubmittedFormModel implements DataModel {
  const SubmittedFormModel({
    required this.id,
    required this.formName,
    required this.submittedAt,
    required this.fields,
    this.isUploaded = false,
  });

  final String id;
  final String formName;
  final DateTime submittedAt;
  final Map<FormFieldModel, dynamic> fields;
  final bool isUploaded;

  SubmittedFormModel copyWith({
    String? formName,
    DateTime? submittedAt,
    Map<FormFieldModel, dynamic>? fields,
    bool? isUploaded,
  }) {
    return SubmittedFormModel(
      id: id,
      formName: formName ?? this.formName,
      submittedAt: submittedAt ?? this.submittedAt,
      fields: fields ?? this.fields,
      isUploaded: isUploaded ?? this.isUploaded,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "formName": formName,
      "submittedAt": submittedAt.millisecondsSinceEpoch,
      "fields": fields.map((k, v) => MapEntry(k.toMap(), v)),
      "isUploaded": isUploaded,
    };
  }

  factory SubmittedFormModel.fromMap(Map<String, dynamic> map) {
    return SubmittedFormModel(
      id: map['id'],
      formName: map['formName'] ?? '',
      submittedAt: DateTime.fromMillisecondsSinceEpoch(map['submittedAt']),
      fields: Map<FormFieldModel, dynamic>.from(
        (map['fields'] as Map).map((k, v) {
          return MapEntry(
            FormFieldModel.fromMap((k as Map).map(
              (k, v) => MapEntry(k.toString(), v),
            )),
            v,
          );
        }),
      ),
      isUploaded: map["isUploaded"] ?? false,
    );
  }
}
