import 'package:dynamic_form/_libraries/hive_storage/hive_box.dart';
import 'package:dynamic_form/_libraries/hive_storage/hive_storage.dart';
import 'package:dynamic_form/_libraries/hive_storage/hive_type_adapter.dart';
import 'package:dynamic_form/models/form_model/submitted_form_model.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:image_picker/image_picker.dart';

class HiveRepository extends HiveStorage {
  HiveRepository(super.hive);

  static HiveRepository find() => getit.get<HiveRepository>();

  late HiveBox<SubmittedFormModel> submittedForms = HiveBox(
    hive,
    "submittedForms",
    adapter: const HiveDataAdapter<SubmittedFormModel>(
      typeId: 1,
      fromMap: SubmittedFormModel.fromMap,
    ),
  );

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

  @override
  List<HiveBox> get boxes => [submittedForms];

  @override
  void registerAdapters() {
    hive.registerAdapter(xFileAdapter);
  }
}
