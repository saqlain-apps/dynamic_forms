part of 'page_indicator.dart';

abstract class PageIndicatorBuilder {
  const PageIndicatorBuilder(this.mainIndicator);

  final PageIndicator mainIndicator;
  int get maxPages => 10;

  List<Widget> generatePages(
    int currentPage,
    Widget Function(int) pageIndicator,
  );
}

class DualPageIndicatorBuilder extends PageIndicatorBuilder {
  const DualPageIndicatorBuilder(super.mainIndicator);

  DualPageOverflowGeneratorWithout get pageOverflowWithout =>
      DualPageOverflowGeneratorWithout(mainIndicator, maxPages: maxPages);

  DualPageOverflowGeneratorWithin get pageOverflowWithin =>
      DualPageOverflowGeneratorWithin(mainIndicator, maxPages: maxPages);

  @override
  List<Widget> generatePages(
    int currentPage,
    Widget Function(int) pageIndicator,
  ) {
    List<Widget> pages;

    if (mainIndicator.totalPages <= 0) {
      // Underflow
      pages = [mainIndicator.emptyIndicator];
    } else if (mainIndicator.totalPages <= maxPages) {
      // Within Limits
      pages = List<Widget>.generate(
        mainIndicator.totalPages,
        (index) => pageIndicator(index + 1),
      );
    } else {
      // Overflow

      if (currentPage < pageOverflowWithout.left ||
          currentPage > pageOverflowWithout.beforeRight) {
        // Overflow Without
        pages = pageOverflowWithout.generatePages(currentPage, pageIndicator);
      } else {
        // Overflow Within
        pages = pageOverflowWithin.generatePages(currentPage, pageIndicator);
      }
    }

    return pages;
  }
}

class DualPageOverflowGeneratorWithout extends PageIndicatorBuilder {
  const DualPageOverflowGeneratorWithout(
    super.mainIndicator, {
    required this.maxPages,
  });

  @override
  final int maxPages;

  int get right => 3;
  int get beforeRight => mainIndicator.totalPages - right;
  int get left => beforeRight.clamp(1, maxPages - right);
  int get afterLeft => left + 1;

  @override
  List<Widget> generatePages(
    int currentPage,
    Widget Function(int) pageIndicator,
  ) {
    return List<Widget>.generate(
      maxPages + 1,
      (index) {
        var page = index + 1;
        if (page <= left) {
          // Left Items
          return pageIndicator(page);
        } else if (page == afterLeft) {
          // Ellipses
          return mainIndicator.ellipses;
        } else {
          // Right Items
          return pageIndicator((page - (afterLeft)) + beforeRight);
        }
      },
    );
  }
}

class DualPageOverflowGeneratorWithin extends PageIndicatorBuilder {
  const DualPageOverflowGeneratorWithin(
    super.mainIndicator, {
    required this.maxPages,
  });

  @override
  final int maxPages;

  int get oddMaxPages => ((((maxPages + 1) ~/ 2) * 2) - 1);
  int get extremePoints => 1;
  int get leftEllipses => extremePoints + 1;
  int get rightEllipses => oddMaxPages - extremePoints;

  @override
  List<Widget> generatePages(
    int currentPage,
    Widget Function(int) pageIndicator,
  ) {
    return List<Widget>.generate(
      oddMaxPages,
      (index) {
        var pIndex = index + 1;
        if (pIndex <= extremePoints) {
          // Left Items
          return pageIndicator(pIndex);
        } else if (pIndex == leftEllipses) {
          // Left Ellipses
          return mainIndicator.ellipses;
        } else if (pIndex > leftEllipses && pIndex < rightEllipses) {
          // Center
          var cIndex = pIndex - leftEllipses;
          var centerPoints = rightEllipses - leftEllipses - 1;
          var cExtremePoints = (centerPoints - 1) ~/ 2;
          var cStartPoint = currentPage - cExtremePoints;

          return pageIndicator(cIndex - 1 + cStartPoint);
        } else if (pIndex == rightEllipses) {
          // Right Ellipses
          return mainIndicator.ellipses;
        } else {
          // Right Items
          return pageIndicator(pIndex - oddMaxPages + mainIndicator.totalPages);
        }
      },
    );
  }
}
