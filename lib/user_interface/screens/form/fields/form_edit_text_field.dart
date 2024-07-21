import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/user_interface/components/multi_field/_src.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:flutter/services.dart';

class FormEditTextField extends DynamicFormField<FormEditTextFieldModel>
    implements StatefulWidget {
  const FormEditTextField({
    required super.fieldData,
    required super.responseController,
    super.key,
  });

  @override
  StatefulElement createElement() => StatefulElement(this);

  @override
  State<FormEditTextField> createState() => _FormEditTextFieldState();
}

class _FormEditTextFieldState extends State<FormEditTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChange() {
    widget.responseController.value = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildWithLabel(
      label: widget.fieldData.label,
      child: AppTextField(
        controller: _controller,
        label:
            "${widget.fieldData.label}${widget.fieldData.mandatory ? "*" : ""}",
        keyboardType: switch (widget.fieldData.inputType) {
          EditTextFieldInputType.text => TextInputType.text,
          EditTextFieldInputType.integer => TextInputType.number,
        },
        floatingLabelBehavior: FloatingLabelBehavior.never,
        inputFormatters: [
          if (widget.fieldData.inputType == EditTextFieldInputType.integer)
            FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
