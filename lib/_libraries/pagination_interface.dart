import 'dart:async';

import 'package:flutter/material.dart';

import 'task_handler/task_handler.dart';

abstract class PaginationInterface<DataType> {
  static void Function() dynamicSearch({
    required List<TextEditingController> searchControllers,
    required void Function(String search) callback,
    int? debounceMilliseconds,
  }) {
    searchHandler(TextEditingController searchController) =>
        callback(searchController.text);

    final callbacks = <TextEditingController, void Function()>{};

    for (var searchController in searchControllers) {
      TimedTaskHandler? debouncer;
      if (debounceMilliseconds != null) {
        debouncer = TimedTaskHandler(debounceMilliseconds);
      }

      void callback() {
        if (debouncer != null) {
          debouncer.handle(() => searchHandler(searchController));
        } else {
          searchHandler(searchController);
        }
      }

      searchController.addListener(callback);
      callbacks[searchController] = callback;
    }

    void dispose() {
      for (var listener in callbacks.entries) {
        listener.key.removeListener(listener.value);
      }
    }

    return dispose;
  }

  static void Function() paginate({
    required List<ScrollController> scrollControllers,
    required VoidCallback callback,
    bool Function()? hasNextPage,
  }) {
    void paginationListener(ScrollController scrollController) {
      if (shouldLoadMore(scrollController) && (hasNextPage?.call() ?? true)) {
        callback();
      }
    }

    final callbacks = <ScrollController, void Function()>{};

    for (var scrollController in scrollControllers) {
      void callback() => paginationListener(scrollController);
      scrollController.addListener(callback);
      callbacks[scrollController] = callback;
    }

    void dispose() {
      for (var listener in callbacks.entries) {
        listener.key.removeListener(listener.value);
      }
    }

    return dispose;
  }

  static bool shouldLoadMore(ScrollController scrollController) =>
      scrollController.position.maxScrollExtent <=
      scrollController.position.pixels;

  PaginationInterface({this.initialPage = 0}) : _page = initialPage;

  final TaskHandler _taskHandler = AsyncHandler();

  final List<DataType> _pagedDataList = [];
  List<DataType> get pagedDataList => List.unmodifiable(_pagedDataList);

  int get limit => 10;
  FutureOr<List<DataType>> callAPI({int from = 0});

  final int initialPage;
  int _page;
  int get page => _page;

  List<DataType>? _lastData;

  bool get hasNextPage {
    if (_lastData != null && _lastData!.length < limit) return false;
    if (page == initialPage) return true;
    return pagedDataList.length >= limit * (page - initialPage);
  }

  void reset() {
    _page = initialPage;
    _pagedDataList.clear();
    _lastData = null;
  }

  void nextPage(List<DataType> data) {
    _lastData = data;
    if (data.isNotEmpty) {
      _pagedDataList.addAll(data);
      _page++;
    }
  }

  FutureOr<List<DataType>> getData() async {
    if (!hasNextPage) return pagedDataList;
    var data = await callAPI(from: page);
    nextPage(data);
    return pagedDataList;
  }

  FutureOr<List<DataType>> getDataSecurely() async {
    final data = await _taskHandler.handleReturn<List<DataType>>(getData);
    return data ?? pagedDataList;
  }

  FutureOr<List<DataType>> getNextPage() async {
    if (!hasNextPage) return [];
    var data = await callAPI(from: page);
    nextPage(data);
    return data;
  }

  FutureOr<List<DataType>> getNextPageSecurely() async {
    final data = await _taskHandler.handleReturn<List<DataType>>(getNextPage);
    return data ?? [];
  }
}

abstract class MultiPaginationInterface<T> extends PaginationInterface<T> {
  List<PaginationInterface<T>> get pagination;

  @override
  bool get hasNextPage => pagination.any((element) => element.hasNextPage);

  @override
  FutureOr<List<T>> callAPI({int from = 0}) async {
    List<T> apiData = [];
    for (var handler in pagination) {
      if (handler.hasNextPage) {
        var response = await handler.getData();
        apiData.addAll(response);
      }
      if (apiData.length >= limit) return apiData;
    }

    return apiData;
  }

  @override
  int get limit => 10;
}
