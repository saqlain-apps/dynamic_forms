import '../../utils/app_helpers/_app_helper_import.dart';

class ConfirmationAlert extends StatelessWidget {
  static Future<T?> showAlert<T>(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    Key? key,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationAlert(
        title: title,
        content: content,
        onConfirm: onConfirm,
      ),
    );
  }

  const ConfirmationAlert({
    required this.title,
    required this.content,
    required this.onConfirm,
    super.key,
  });

  final String title;
  final String content;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppStyles.of(context).sLarge.wBold,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: AppStyles.of(context),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                const Divider(
                  thickness: .5,
                  height: .5,
                  color: AppColors.black,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.maybePop(context);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'No',
                                style: AppStyles.of(context).sLarge.wBold.cRed,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: .5,
                        width: .5,
                        color: AppColors.black,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onConfirm();
                            Navigator.maybePop(context);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Yes',
                                style: AppStyles.of(context).sLarge.wBold.cRed,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
