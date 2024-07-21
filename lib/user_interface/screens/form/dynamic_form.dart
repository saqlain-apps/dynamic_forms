import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/models/form_model/form_model.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';

import 'dynamic_form_field.dart';

class DynamicFormBuilder extends StatefulWidget {
  const DynamicFormBuilder({
    required this.form,
    required this.builder,
    required this.responseController,
    super.key,
  });

  final FormModel form;
  final Widget Function(List<Widget> children) builder;
  final ValueNotifier<Map<FormFieldModel, dynamic>> responseController;

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  final Map<FormFieldModel, dynamic> _response = {};
  late final Map<FormFieldModel, ValueNotifier<dynamic>> _responseControllers;

  @override
  void initState() {
    super.initState();
    _responseControllers = Map.unmodifiable(Map.fromEntries(widget.form.fields
        .map((e) => MapEntry(e, ValueNotifier<dynamic>(null)))));
    for (var entry in _responseControllers.entries) {
      final fieldData = entry.key;
      final controller = entry.value;
      controller.addListener(() => _onChange(fieldData, controller));
      _response[fieldData] = {};
    }
  }

  @override
  void dispose() {
    for (var notifier in _responseControllers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  void _onChange(
    FormFieldModel fieldData,
    ValueNotifier<dynamic> controller,
  ) {
    _response[fieldData] = controller.value;
    widget.responseController.value = Map.unmodifiable(_response);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _responseControllers.entries
          .map((e) => DynamicFormField.formBuilder(
                fieldData: e.key,
                responseController: e.value,
              ))
          .toList(),
    );
  }
}
