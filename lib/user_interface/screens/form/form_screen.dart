import 'package:dynamic_form/_libraries/widgets/remote_data_builder.dart';
import 'package:dynamic_form/_libraries/widgets/tap_unfocus.dart';
import 'package:dynamic_form/controllers/app/app_controller.dart';
import 'package:dynamic_form/models/form_model/form_model.dart';
import 'package:dynamic_form/user_interface/screens/form/dynamic_form.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/_libraries/bloc/bloc_view.dart';
import '/controllers/form/form_controller.dart';

class FormScreen extends BlocView<FormController, FormScreenState> {
  static Widget get provider {
    return BlocProvider(
      create: (context) => FormController(context.read<AppController>()),
      child: const FormScreen(),
    );
  }

  const FormScreen({super.key});

  @override
  void blocListener(
    BuildContext context,
    FormScreenState state,
    FormController controller,
  ) {
    if (state.status.isSuccess) {
      // Success
      switch (state.event) {
        case FormSubmitFormEvent():
          Messenger()
              .snackbarMessenger
              .infoSnackbar
              .show("Form Submitted Successfully");
          Messenger().navigator.pop();
          break;
        default:
      }
    } else if (state.status.isFailed) {
      // Failed
      var failureMessage = state.message;

      if (isBlank(failureMessage)) {
        failureMessage = switch (state.event) {
          FormFetchFormEvent() =>
            "Failed to load form, please try again later.",
          FormSubmitFormEvent() =>
            "Failed to submit form, please try again later.",
          _ => failureMessage,
        };
      }

      if (isNotBlank(failureMessage)) {
        Messenger().notificationMessenger.errorMessage.show(failureMessage!);
      }
    }
  }

  @override
  Widget buildContent(
    BuildContext context,
    FormScreenState state,
    FormController controller,
  ) {
    return TapUnfocus(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.form?.formName ?? 'Form Name'),
          centerTitle: true,
        ),
        body: RemoteDataBuilder<FormModel>(
          data: state.form,
          isLoading: state.isLoading(FormFetchFormEvent),
          loadingIndicator: RemoteDataBuilder.defaultLoadingIndicator,
          failureBuilder: (context) {
            return Center(
              child: IconButton.filled(
                iconSize: 48,
                onPressed: () {
                  controller.add(const FormFetchFormEvent());
                },
                icon: const Icon(Icons.replay),
              ),
            );
          },
          builder: (context, form) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Mandatory fields are marked with asterisk(*).',
                    style: AppStyles.of(context),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DynamicFormBuilder(
                    form: form,
                    builder: (children) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16) +
                            const EdgeInsets.only(top: 16, bottom: 24),
                        itemCount: children.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) => children[index],
                      );
                    },
                    responseController: state.store.responseController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                        top: 16,
                        bottom: MediaQuery.paddingOf(context)
                            .bottom
                            .clamp(24, double.infinity),
                      ) +
                      const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        offset: const Offset(0, -2),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: state.store.responseController,
                          builder: (context, response, child) {
                            final isValidated = response.isNotEmpty
                                ? response.entries.fold(
                                    true,
                                    (acc, val) {
                                      final fieldValidated = val.key.mandatory
                                          ? isNotBlank(val.value)
                                          : true;
                                      return acc && fieldValidated;
                                    },
                                  )
                                : false;
                            return ElevatedButton(
                              onPressed: isValidated &&
                                      !state.isLoading(FormSubmitFormEvent)
                                  ? () {
                                      controller
                                          .add(const FormSubmitFormEvent());
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: state.isLoading(FormSubmitFormEvent)
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : const Text("Submit"),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
