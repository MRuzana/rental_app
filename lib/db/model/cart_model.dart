import 'package:hive_flutter/hive_flutter.dart';
 part 'cart_model.g.dart';

@HiveType(typeId: 2)
class CartModel{

  @HiveField(0)
  final int id;

  @HiveField(1)
  int? cartId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String price;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String details;
  
  @HiveField(6)
  final String imagePath;

  @HiveField(7)
  int? quantity;

  @HiveField(8)
  int itemStock;

  CartModel({required this.name, required this.price, required this.category, required this.details, required this.imagePath,required this.id,required this.itemStock, this.quantity,this.cartId});  
}