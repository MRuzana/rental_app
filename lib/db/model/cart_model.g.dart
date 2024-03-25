// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 2;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      name: fields[2] as String,
      price: fields[3] as String,
      category: fields[4] as String,
      details: fields[5] as String,
      imagePath: fields[6] as String,
      id: fields[0] as int,
      itemStock: fields[8] as int,
      quantity: fields[7] as int?,
      cartId: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cartId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.details)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.itemStock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
