library pagination_indicator;

import 'dart:async';

import 'package:flutter/material.dart';

part 'page_indicator_builder.dart';

class PageIndicator extends StatefulWidget {
  final int totalLength;
  final FutureOr<void> Function(int pageNumber) update;

  const PageIndicator({
    required this.totalLength,
    required this.update,
    super.key,
  });

  int get limit => 10;
  int get maxPages => 10;
  int get totalPages => (totalLength / limit).ceil();
  Widget get pageSpacing => const SizedBox(width: 2);
  Widget get spacing => const SizedBox(width: 10);

  Widget get ellipses => const Text('...');

  Widget get emptyIndicator => indicator(
        child: selectedPage(0),
        update: () => update(0),
      );

  PageIndicatorBuilder get pageGenerator => DualPageIndicatorBuilder(this);

  Widget page(int pageNumber) {
    return Text(pageNumber.toString());
  }

  Widget selectedPage(int pageNumber) {
    return Text('[$pageNumber]');
  }

  Widget next(int pageNumber) {
    return const Icon(Icons.arrow_forward_ios);
  }

  Widget previous(int pageNumber) {
    return const Icon(Icons.arrow_back_ios);
  }

  Widget extraInfo(
    int currentPage,
    FutureOr<void> Function(int pageNumber) update,
  ) {
    return const SizedBox();
  }

  Widget indicator({
    required Widget child,
    required FutureOr<void> Function() update,
  }) {
    return InkWell(
      onTap: update,
      child: child,
    );
  }

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void didUpdateWidget(covariant PageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalLength != widget.totalLength) {
      _currentPage = 0;
      _initPage();
    }
  }

  void _initPage() {
    if (widget.totalLength > 0) _currentPage = 1;
  }

  FutureOr<void> update(int pageNumber) async {
    if (pageNumber > widget.totalPages || pageNumber < 1) return;
    await widget.update(pageNumber);
    _currentPage = pageNumber;
    setState(() {});
  }

  Widget next() {
    return widget.indicator(
      child: widget.next(_currentPage),
      update: () => update(_currentPage + 1),
    );
  }

  Widget previous() {
    return widget.indicator(
      child: widget.previous(_currentPage),
      update: () => update(_currentPage - 1),
    );
  }

  Widget pageIndicator(int pageNumber) {
    var page = pageNumber == _currentPage
        ? widget.selectedPage(pageNumber)
        : widget.page(pageNumber);

    return widget.indicator(
      child: page,
      update: () => update(pageNumber),
    );
  }

  Widget buildPages() {
    // Generate Pages
    var pages = widget.pageGenerator.generatePages(_currentPage, pageIndicator);

    // Add Spacing
    pages = pages.expand((page) => [page, widget.pageSpacing]).toList()
      ..removeLast();

    return Row(mainAxisSize: MainAxisSize.min, children: pages);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        previous(),
        widget.spacing,
        buildPages(),
        widget.spacing,
        next(),
        widget.extraInfo(_currentPage, update)
      ],
    );
  }
}
