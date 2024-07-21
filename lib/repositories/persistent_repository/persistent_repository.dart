import '../../_libraries/_interfaces/base_repository.dart';
import '../../_libraries/persistent_storage.dart';

class PersistentRepository implements BaseRepository {
  PersistentRepository(this.storage);
  final PersistentStorage storage;
  //----------------------------------------------------------------------------
  /// Example
  late final example = PersistentData<String>(storage, key: 'example');
}
