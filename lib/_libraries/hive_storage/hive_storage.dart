import 'package:hive_flutter/hive_flutter.dart';

import 'hive_box.dart';

class HiveStorage {
  const HiveStorage(this.hive);
  final HiveInterface hive;

  List<HiveBox> get boxes => [];

  void registerAdapters() {}

  Future<void> init() async {
    await hive.initFlutter();
    registerAdapters();
    await initBoxes();
  }

  Future<void> initBoxes() async {
    for (var box in boxes) {
      await box.init();
    }
  }

  Future<void> dispose() async {
    for (var box in boxes) {
      await box.close();
    }
  }
}
