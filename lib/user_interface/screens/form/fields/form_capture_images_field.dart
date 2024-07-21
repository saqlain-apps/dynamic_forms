import 'package:dynamic_form/_libraries/media_access.dart';
import 'package:dynamic_form/_libraries/widgets/prototype_item.dart';
import 'package:dynamic_form/_libraries/widgets/value_transitioned_builder.dart';
import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/user_interface/components/multi_media_picker.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:image_picker/image_picker.dart';

class FormCaptureImagesField
    extends DynamicFormField<FormCaptureImagesFieldModel>
    implements StatelessWidget {
  const FormCaptureImagesField({
    required super.fieldData,
    required super.responseController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildWithLabel(
      label: fieldData.label,
      child: PrototypeItem(
        prototype: const SizedBox.square(dimension: 100),
        child: ValueTransitionedBuilder<List<XFile>>(
          initialValue: const [],
          onChanged: (value) {
            if (value.length == fieldData.imageCount) {
              responseController.value = value;
            } else {
              responseController.value = null;
            }
          },
          builder: (context, value, notifier, update, child) {
            return MultiMediaPicker(
              controller: notifier,
              picker: (context, {limit, selectedMedia}) async {
                if (limit != null && (selectedMedia ?? []).length >= limit) {
                  return null;
                }

                var image = await getit
                    .get<MediaAccess>()
                    .pickImage(ImageSource.camera);

                return image != null ? [image] : null;
              },
              limit: fieldData.imageCount,
            );
          },
        ),
      ),
    );
  }

  @override
  StatelessElement createElement() => StatelessElement(this);
}
