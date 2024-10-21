import 'package:hive_flutter/hive_flutter.dart';
part 'bill_model.g.dart';

@HiveType(typeId: 3)
class BillDetailsModel{

@HiveField(0)
int? bookingId;

@HiveField(1)
final String customerName;

@HiveField(2)
final String customerAddress;

@HiveField(4)
final String customerPlace;

@HiveField(5)
final String customerMobileNo;

@HiveField(6)
final String eventDate;

@HiveField(7)
final int billNo;

@HiveField(8)
final String returnDate;

@HiveField(9)
final double totalAmount;

@HiveField(10)
final double advancePaid;

@HiveField(11)
final double balanceAmount;

@HiveField(12)
final List<Map<String, dynamic>> cartItems;

@HiveField(13)
bool? isSettled;

@HiveField(14)
String? billingDate;

@HiveField(15)
String? customerMail;


BillDetailsModel({
  required this.billNo,
  required this.customerName,
  required this.customerAddress,
  required this.customerPlace,
  required this.customerMobileNo,
  required this.eventDate,
  required this.returnDate,
  required this.totalAmount,
  required this.advancePaid,
  required this.balanceAmount,
  required this.cartItems,
  required this.customerMail,
  this.billingDate,
  this.isSettled=false,
  this.bookingId,
  });

}