import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';

class FormRadioGroupField extends DynamicFormField<FormRadioGroupFieldModel>
    implements StatelessWidget {
  const FormRadioGroupField({
    required super.fieldData,
    required super.responseController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildWithLabel(
      label: fieldData.label,
      child: ValueListenableBuilder(
        valueListenable: responseController,
        builder: (context, response, child) {
          final optionLength = fieldData.options
              .fold(fieldData.options[0],
                  (acc, val) => acc.length > val.length ? acc : val)
              .length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fieldData.options
                .map<Widget>((option) {
                  final isSelected = responseController.value == option;
                  return GestureDetector(
                    onTap: () {
                      responseController.value = option;
                    },
                    child: Row(
                      children: [
                        const Gap(12),
                        Text(
                          option.padRight(optionLength),
                          style: AppStyles.of(context).sMedium,
                        ),
                        const Gap(16),
                        _radio(isSelected),
                      ],
                    ),
                  );
                })
                .toList()
                .separated((_) => const Gap(4)),
          );
        },
      ),
    );
  }

  Widget _radio(bool isSelected) {
    return Builder(builder: (context) {
      final color = isSelected
          ? AppColors.darken(AppColors.of(context).primary, .2)
          : AppColors.of(context).disabled;
      return Container(
        width: 16,
        height: 16,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: isSelected
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              )
            : null,
      );
    });
  }

  @override
  StatelessElement createElement() => StatelessElement(this);
}
