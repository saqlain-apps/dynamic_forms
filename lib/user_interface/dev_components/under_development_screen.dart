import '../../utils/app_helpers/_app_helper_import.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  static Widget screen() {
    return const Scaffold(body: UnderDevelopmentScreen());
  }

  const UnderDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Under Development...',
        style: TextStyle(color: AppColors.black, fontSize: 18),
      ),
    );
  }
}
