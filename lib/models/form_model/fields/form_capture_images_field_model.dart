import '../form_field_model.dart';

class FormCaptureImagesFieldModel extends FormFieldModel {
  const FormCaptureImagesFieldModel({
    required this.label,
    required this.imageCount,
    required this.folderName,
    required this.mandatory,
  });

  final String label;
  final int imageCount;
  final String folderName;

  @override
  final bool mandatory;

  @override
  String get componentType => "CaptureImages";

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'meta_info': {
        'label': label,
        'no_of_images_to_capture': imageCount,
        'saving_folder': folderName,
        'mandatory': mandatory,
      },
    };
  }

  factory FormCaptureImagesFieldModel.fromMap(Map<String, dynamic> map) {
    return FormCaptureImagesFieldModel(
      label: map['label'] ?? '',
      imageCount: map['no_of_images_to_capture']?.toInt() ?? 0,
      folderName: map['saving_folder'] ?? '',
      mandatory: FormFieldModel.isMandatory(map),
    );
  }
}
