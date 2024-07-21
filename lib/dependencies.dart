import 'package:dynamic_form/firebase_services/firebase_root.dart';
import 'package:dynamic_form/repositories/background_tasks_repository/background_tasks_repository.dart';
import 'package:dynamic_form/repositories/hive_repository/hive_repository.dart';
import 'package:dynamic_form/repositories/storage_repository/storage_repository.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/repositories/api_repository/api_repository.dart';
import '/repositories/persistent_repository/persistent_repository.dart';
import '_libraries/http_services/http_services.dart';
import '_libraries/life_cycle_manager.dart';
import '_libraries/media_access.dart';
import '_libraries/persistent_storage.dart';
import 'utils/app_helpers/_app_helper_import.dart';
import 'utils/dependency.dart';

abstract class DependencyManager<T extends Widget> extends LifeCycleManager<T> {
  static List<Dependency> buildDependencies({
    PersistentStorage? persistentStorage,
    PersistentRepository Function()? persistentRepository,
    HttpServices? httpServices,
    ApiRepository Function()? apiRepo,
    MediaAccess? mediaAccess,
  }) {
    return [
      Dependency<PersistentStorage>(
        create: () async =>
            persistentStorage ?? await PersistentStorage().init(),
      ),
      Dependency<PersistentRepository>(
        create: persistentRepository ??
            () => PersistentRepository(getit.get<PersistentStorage>()),
      ),
      Dependency<HttpServices>.value(
        value: httpServices ?? HttpServices(),
        dispose: (e) => e.dispose(),
      ),
      Dependency<ApiRepository>(
        create: apiRepo ?? () => ApiRepository(getit.get<HttpServices>()),
      ),
      Dependency<FirebaseRoot>(
        create: () async {
          final firebase = FirebaseRoot();
          await firebase.initialize();
          return firebase;
        },
      ),
      Dependency<StorageRepository>(
        create: () => StorageRepository(
          getit.get<FirebaseRoot>().storageServices,
        ),
      ),
      Dependency<MediaAccess>.value(
        value: mediaAccess ?? MediaAccess(ImagePicker()),
      ),
      Dependency<HiveRepository>(
        create: () async {
          final repo = HiveRepository(Hive);
          await repo.init();
          return repo;
        },
        dispose: (element) => element.dispose(),
      ),
      Dependency<BackgroundTasksRepository>(
        create: () async {
          final repo = BackgroundTasksRepository(FlutterBackgroundService());
          await repo.init();
          return repo;
        },
        dispose: (element) => element.dispose(),
      ),
    ];
  }

  DependencyManager([DependencyHandler? dependencyHandler])
      : _dependencyHandler = dependencyHandler ??
            DependencyHandler(dependencies: buildDependencies());

  final DependencyHandler _dependencyHandler;

  @override
  Future<void> init() async {
    await super.init();
    await _dependencyHandler.registerDependencies();
  }

  @override
  void dispose() {
    _dependencyHandler.unregisterDependencies();
    super.dispose();
  }
}
