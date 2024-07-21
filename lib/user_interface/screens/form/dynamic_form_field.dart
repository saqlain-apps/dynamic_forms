import 'package:dynamic_form/_libraries/automatic_keep_alive.dart';
import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';

import 'fields/form_capture_images_field.dart';
import 'fields/form_check_boxes_field.dart';
import 'fields/form_drop_down_field.dart';
import 'fields/form_edit_text_field.dart';
import 'fields/form_radio_group_field.dart';

export 'fields/form_capture_images_field.dart';
export 'fields/form_check_boxes_field.dart';
export 'fields/form_drop_down_field.dart';
export 'fields/form_edit_text_field.dart';
export 'fields/form_radio_group_field.dart';

abstract class DynamicFormField<T extends FormFieldModel> extends Widget {
  const DynamicFormField({
    required this.fieldData,
    required this.responseController,
    super.key,
  });

  final ValueNotifier<dynamic> responseController;
  final T fieldData;

  static Widget formBuilder<T extends FormFieldModel>({
    required T fieldData,
    required ValueNotifier<dynamic> responseController,
    Key? key,
  }) {
    return switch (fieldData) {
      FormEditTextFieldModel() => FormEditTextField(
          fieldData: fieldData,
          responseController: responseController,
          key: key,
        ),
      FormCheckBoxesFieldModel() => FormCheckBoxesField(
          fieldData: fieldData,
          responseController: responseController,
          key: key,
        ),
      FormDropDownFieldModel() => FormDropDownField(
          fieldData: fieldData,
          responseController: responseController,
          key: key,
        ),
      FormCaptureImagesFieldModel() => FormCaptureImagesField(
          fieldData: fieldData,
          responseController: responseController,
          key: key,
        ),
      FormRadioGroupFieldModel() => FormRadioGroupField(
          fieldData: fieldData,
          responseController: responseController,
          key: key,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget buildWithLabel({required String label, required Widget child}) {
    return AlwaysKeepAlive(
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$label${fieldData.mandatory ? "*" : ""}",
              style: AppStyles.of(context).sMedium,
            ),
            const Gap(4),
            child,
          ],
        );
      }),
    );
  }
}
