import 'package:dynamic_form/_libraries/widgets/remote_data_builder.dart';
import 'package:dynamic_form/controllers/app/app_controller.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/_libraries/bloc/bloc_view.dart';
import '/controllers/home/home_controller.dart';

class HomeScreen extends BlocView<HomeController, HomeState> {
  static Widget get provider {
    return BlocProvider(
      create: (context) => HomeController(context.read<AppController>()),
      child: const HomeScreen(),
    );
  }

  const HomeScreen({super.key});

  @override
  void blocListener(
    BuildContext context,
    HomeState state,
    HomeController controller,
  ) {
    if (state.status.isSuccess) {
      // Success
    } else if (state.status.isFailed) {
      // Failed
    }
  }

  @override
  Widget buildContent(
    BuildContext context,
    HomeState state,
    HomeController controller,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        centerTitle: true,
      ),
      body: state.isLoading(HomeSyncEvent)
          ? RemoteDataBuilder.defaultLoadingIndicator(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.submittedForms.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final formData =
                          state.submittedForms.entries.elementAt(index);
                      final form = formData.key;
                      final isLoading = formData.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    form.formName,
                                    style:
                                        AppStyles.of(context).sMedium.wSemiBold,
                                  ),
                                  Text(
                                    DateFormat("LLL dd")
                                        .add_jm()
                                        .format(form.submittedAt),
                                    style: AppStyles.of(context),
                                  ),
                                ],
                              ),
                            ),
                            isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    form.isUploaded
                                        ? "Uploaded"
                                        : "Waiting for internet",
                                    style: AppStyles.of(context)
                                        .wSemiBold
                                        .colored(form.isUploaded
                                            ? AppColors.green
                                            : AppColors.red),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: state.isLoading(HomeSyncEvent)
          ? null
          : FloatingActionButton(
              onPressed: () {
                Messenger().navigator.pushNamed(AppRoutes.form.name);
              },
              child: const Icon(Icons.create),
            ),
    );
  }
}
