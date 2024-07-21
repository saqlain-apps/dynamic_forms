import 'package:dynamic_form/_libraries/_interfaces/base_repository.dart';
import 'package:dynamic_form/models/form_model/submitted_form_model.dart';
import 'package:dynamic_form/utils/hive_type_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HiveRepository implements BaseRepository {
  HiveRepository(this.hive);
  final HiveInterface hive;

  Future<void> init() async {
    await hive.initFlutter();
    _registerAdapters();
    await initBoxes();
  }

  void _registerAdapters() {
    hive.registerAdapter(xFileAdapter);
    hive.registerAdapter(submittedFormAdapter);
  }

  Future<void> initBoxes() async {
    submittedForms = await hive.openBox("submittedForms");
  }

  late Box<SubmittedFormModel> submittedForms;

  late final HiveTypeAdapter<XFile> xFileAdapter = HiveCustomAdapter<XFile>(
    typeId: 0,
    fromMap: (map) => XFile(
      map["path"],
      mimeType: map["mime"],
      name: map["name"],
    ),
    toMap: (obj) => {
      "path": obj.path,
      "name": obj.name,
      "mime": obj.mimeType,
    },
  );

  late final HiveTypeAdapter<SubmittedFormModel> submittedFormAdapter =
      const HiveDataAdapter<SubmittedFormModel>(
    typeId: 1,
    fromMap: SubmittedFormModel.fromMap,
  );

  Future<void> dispose() async {
    await submittedForms.close();
  }
}
