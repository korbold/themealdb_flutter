import 'package:hive/hive.dart';
import 'local_preference_model.dart';

/// Hive adapter for LocalPreferenceModel
class LocalPreferenceModelAdapter extends TypeAdapter<LocalPreferenceModel> {
  @override
  final int typeId = 0;

  @override
  LocalPreferenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalPreferenceModel(
      id: fields[0] as String,
      customName: fields[1] as String,
      apiMealId: fields[2] as String,
      apiMealName: fields[3] as String,
      imageUrl: fields[4] as String?,
      category: fields[5] as String?,
      area: fields[6] as String?,
      instructions: fields[7] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
    );
  }

  @override
  void write(BinaryWriter writer, LocalPreferenceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customName)
      ..writeByte(2)
      ..write(obj.apiMealId)
      ..writeByte(3)
      ..write(obj.apiMealName)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.area)
      ..writeByte(7)
      ..write(obj.instructions)
      ..writeByte(8)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalPreferenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

