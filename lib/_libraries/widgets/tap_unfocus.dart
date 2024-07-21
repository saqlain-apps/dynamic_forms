import '../../utils/app_helpers/_app_helper_import.dart';

class TapUnfocus extends StatelessWidget {
  const TapUnfocus({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
