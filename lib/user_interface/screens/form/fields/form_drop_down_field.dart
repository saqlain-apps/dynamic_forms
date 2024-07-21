import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/user_interface/components/multi_field/_src.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';

class FormDropDownField extends DynamicFormField<FormDropDownFieldModel>
    implements StatelessWidget {
  const FormDropDownField({
    required super.fieldData,
    required super.responseController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildWithLabel(
      label: fieldData.label,
      child: DropdownField<String>(
        items: DropdownField.defaultItemBuilder(fieldData.options, (e) => e),
        value: responseController.value,
        hint: "None",
        onChanged: (value) => responseController.value = value,
      ),
    );
  }

  @override
  StatelessElement createElement() => StatelessElement(this);
}
