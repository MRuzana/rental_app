
import 'package:hive_flutter/hive_flutter.dart';
 part 'add_product_model.g.dart';


@HiveType(typeId: 1)
class AddProductmodel{

  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String price;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String details;
  
  @HiveField(5)
  final String imagePath;

  @HiveField(6)
  final int quantity;  
  AddProductmodel({required this.name, required this.price, required this.category, required this.details,required this.imagePath,required this.quantity,this.id});

}