import 'package:dynamic_form/_libraries/_interfaces/data_model.dart';

import 'fields/form_capture_images_field_model.dart';
import 'fields/form_check_boxes_field_model.dart';
import 'fields/form_drop_down_field_model.dart';
import 'fields/form_edit_text_field_model.dart';
import 'fields/form_radio_group_field_model.dart';

export 'fields/form_capture_images_field_model.dart';
export 'fields/form_check_boxes_field_model.dart';
export 'fields/form_drop_down_field_model.dart';
export 'fields/form_edit_text_field_model.dart';
export 'fields/form_radio_group_field_model.dart';

abstract class FormFieldModel implements DataModel {
  const FormFieldModel();

  String get componentType;
  bool get mandatory;

  @override
  Map<String, dynamic> toMap() {
    return {'component_type': componentType};
  }

  factory FormFieldModel.fromMap(Map<String, dynamic> map) {
    final type = map['component_type'];
    final metaInfo = map['meta_info'];
    return switch (type) {
      "EditText" => FormEditTextFieldModel.fromMap(metaInfo),
      "CheckBoxes" => FormCheckBoxesFieldModel.fromMap(metaInfo),
      "DropDown" => FormDropDownFieldModel.fromMap(metaInfo),
      "CaptureImages" => FormCaptureImagesFieldModel.fromMap(metaInfo),
      "RadioGroup" => FormRadioGroupFieldModel.fromMap(metaInfo),
      _ => throw UnsupportedError("$type field is not supported.")
    };
  }

  static bool isMandatory(Map<String, dynamic> map) {
    return switch (map['mandatory']) {
      "yes" => true,
      "no" => false,
      _ => false,
    };
  }
}

abstract class FormMultiSelectionFieldModel extends FormFieldModel {
  const FormMultiSelectionFieldModel({
    required this.label,
    required this.options,
    required this.mandatory,
  });

  final String label;
  final List<String> options;

  @override
  final bool mandatory;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'meta_info': {
        'label': label,
        'options': options,
        'mandatory': mandatory,
      },
    };
  }

  static Map<String, dynamic> mapped(Map<String, dynamic> map) {
    return {
      "label": map['label'] ?? '',
      "options": List<String>.from(map['options']),
      "mandatory": FormFieldModel.isMandatory(map),
    };
  }
}
