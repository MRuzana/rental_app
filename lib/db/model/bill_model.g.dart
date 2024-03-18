// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillDetailsModelAdapter extends TypeAdapter<BillDetailsModel> {
  @override
  final int typeId = 3;

  @override
  BillDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillDetailsModel(
      billNo: fields[7] as int,
      customerName: fields[1] as String,
      customerAddress: fields[2] as String,
      customerPlace: fields[4] as String,
      customerMobileNo: fields[5] as String,
      eventDate: fields[6] as String,
      returnDate: fields[8] as String,
      totalAmount: fields[9] as double,
      advancePaid: fields[10] as double,
      balanceAmount: fields[11] as double,
      cartItems: (fields[12] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      customerMail: fields[15] as String?,
      billingDate: fields[14] as String?,
      isSettled: fields[13] as bool?,
      bookingId: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BillDetailsModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.customerAddress)
      ..writeByte(4)
      ..write(obj.customerPlace)
      ..writeByte(5)
      ..write(obj.customerMobileNo)
      ..writeByte(6)
      ..write(obj.eventDate)
      ..writeByte(7)
      ..write(obj.billNo)
      ..writeByte(8)
      ..write(obj.returnDate)
      ..writeByte(9)
      ..write(obj.totalAmount)
      ..writeByte(10)
      ..write(obj.advancePaid)
      ..writeByte(11)
      ..write(obj.balanceAmount)
      ..writeByte(12)
      ..write(obj.cartItems)
      ..writeByte(13)
      ..write(obj.isSettled)
      ..writeByte(14)
      ..write(obj.billingDate)
      ..writeByte(15)
      ..write(obj.customerMail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
