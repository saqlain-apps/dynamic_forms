import 'package:dynamic_form/_libraries/_interfaces/data_model.dart';
import 'package:dynamic_form/utils/app_helpers/app_methods.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveTypeAdapter<T> implements TypeAdapter<T> {
  const HiveTypeAdapter();

  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T obj);

  @override
  T read(BinaryReader reader) {
    var map = const AppMethods().castMapRecursive(reader.readMap());
    return fromMap(map as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, T obj) {
    writer.writeMap(toMap(obj));
  }
}

class HiveDataAdapter<T extends DataModel> extends HiveTypeAdapter<T> {
  const HiveDataAdapter({
    required this.typeId,
    required T Function(Map<String, dynamic> map) fromMap,
  }) : _fromMap = fromMap;

  @override
  final int typeId;

  final T Function(Map<String, dynamic> map) _fromMap;

  @override
  T fromMap(Map<String, dynamic> map) => _fromMap(map);

  @override
  Map<String, dynamic> toMap(T obj) => obj.toMap();
}

class HiveCustomAdapter<T> extends HiveTypeAdapter<T> {
  const HiveCustomAdapter({
    required this.typeId,
    required T Function(Map<String, dynamic> map) fromMap,
    required Map<String, dynamic> Function(T obj) toMap,
  })  : _fromMap = fromMap,
        _toMap = toMap;

  @override
  final int typeId;

  final T Function(Map<String, dynamic> map) _fromMap;

  final Map<String, dynamic> Function(T obj) _toMap;

  @override
  T fromMap(Map<String, dynamic> map) => _fromMap(map);

  @override
  Map<String, dynamic> toMap(T obj) => _toMap(obj);
}
