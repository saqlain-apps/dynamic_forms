import 'dart:async';

import 'package:dynamic_form/_libraries/_interfaces/base_repository.dart';
import 'package:dynamic_form/controllers/app/app_controller.dart';
import 'package:dynamic_form/dependencies.dart';
import 'package:dynamic_form/repositories/hive_repository/hive_repository.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:dynamic_form/utils/dependency.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundTasksRepository implements BaseRepository {
  const BackgroundTasksRepository(this.service);
  final FlutterBackgroundService service;

  Future<void> init() async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        onBackground: iosBackground,
        onForeground: onStart,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
    );
  }

  @pragma('vm:entry-point')
  static FutureOr<bool> iosBackground(ServiceInstance service) async {
    // DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // DartPluginRegistrant.ensureInitialized();
    final DependencyHandler dependencyHandler = DependencyHandler(
        dependencies: DependencyManager.buildDependencies()..removeLast());

    Future<void> stop() async {
      await service.stopSelf();
      dependencyHandler.unregisterDependencies();
    }

    service.on("stop").listen((event) => stop());

    await dependencyHandler.registerDependencies();
    final hiveRepo = getit.get<HiveRepository>();
    await hiveRepo.init();
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (await AppController.checkInternet()) {
        var forms = AppController.formsToBeUploaded(
            hiveRepo.submittedForms.values.toList());
        if (forms.isEmpty) {
          service.invoke("stop");
          timer.cancel();
          return;
        }

        for (var form in forms) {
          var uploaded = await AppController.uploadForm(form);
          if (uploaded != null) AppController.putToDB(uploaded);
        }
      }
    });
  }

  void dispose() {
    service.invoke("stop");
  }
}
