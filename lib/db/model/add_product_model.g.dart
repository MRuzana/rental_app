// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddProductmodelAdapter extends TypeAdapter<AddProductmodel> {
  @override
  final int typeId = 1;

  @override
  AddProductmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddProductmodel(
      name: fields[1] as String,
      price: fields[2] as String,
      category: fields[3] as String,
      details: fields[4] as String,
      imagePath: fields[5] as String,
      stockNumber: fields[6] as int,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AddProductmodel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.stockNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddProductmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
