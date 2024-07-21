import '/utils/app_helpers/_app_helper_import.dart';

class SimplePageIndicator extends StatelessWidget {
  static const int totalPages = 5;

  const SimplePageIndicator(
    this.pageNumber, {
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
    super.key,
  }) : assert(pageNumber < totalPages && pageNumber >= 0,
            "Invalid Page Indicator Number");

  final Color activeColor;
  final Color inactiveColor;
  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        return Padding(
          padding:
              index == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 10),
          child: SingularPageIndicator(
            index == pageNumber,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        );
      }),
    );
  }
}

class SingularPageIndicator extends StatelessWidget {
  const SingularPageIndicator(
    this.active, {
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
    super.key,
  });

  final Color activeColor;
  final Color inactiveColor;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: (active ? 25 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: active ? activeColor : inactiveColor,
      ),
    );
  }
}
