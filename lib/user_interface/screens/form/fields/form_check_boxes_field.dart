import 'package:dynamic_form/_libraries/widgets/multi_selection.dart';
import 'package:dynamic_form/_libraries/widgets/value_transitioned_builder.dart';
import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';

class FormCheckBoxesField extends DynamicFormField<FormCheckBoxesFieldModel>
    implements StatelessWidget {
  const FormCheckBoxesField({
    required super.fieldData,
    required super.responseController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildWithLabel(
      label: fieldData.label,
      child: ValueTransitionedBuilder(
        initialValue: Map.fromEntries(fieldData.options.map(
          (e) => MapEntry(e, false),
        )),
        onChanged: (value) {
          responseController.value =
              value.entries.where((e) => e.value).map((e) => e.key).toList();
        },
        builder: (context, value, notifier, update, child) {
          return MultiSelection(selections: notifier);
        },
      ),
    );
  }

  @override
  StatelessElement createElement() => StatelessElement(this);
}
