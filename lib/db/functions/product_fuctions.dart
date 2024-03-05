import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/db/model/cart_model.dart';

ValueNotifier<List<AddProductmodel>>productListNotifier=ValueNotifier([]);
ValueNotifier<List<String>>catogoriesNotifier=ValueNotifier([]);

Future <void> addProduct(AddProductmodel value)async{
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  final id = await productDB.add(value);
  value.id = id;
   await productDB.put(value.id,value);
  //productListNotifier.value.add(value);
  productListNotifier.notifyListeners();
 // await productDB.close();
}
Future <void>getAllProducts()async{
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  print('Product List: ${productDB.values.toList()}');
  productListNotifier.value.clear();
  productListNotifier.value.addAll(productDB.values);
  productListNotifier.notifyListeners();
}

Future<void>deleteProduct(int id)async{
  print('productid home$id');
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  final cartDB=await Hive.openBox<CartModel>('cart_db');
 
   if (isItemInCart(id)) {
    print('productid in cart$id');
    await cartDB.delete(id);
    cartItemListNotifier.notifyListeners();
    getAllCartItems();
  }

  await productDB.delete(id);
  await getAllProducts();
  await getCategory();
  
  productListNotifier.notifyListeners();
  catogoriesNotifier.notifyListeners();
 
}
Future<void>editProduct(updatedProduct,id)async{
   final productDB=await Hive.openBox<AddProductmodel>('product_db');
   await productDB.put(updatedProduct.id,updatedProduct);
}

Future<List<String>>getCategory()async{
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  final categories = productDB.values.map((category) => category.category).toSet().toList();
  catogoriesNotifier.value.clear();
  catogoriesNotifier.value.addAll(categories);
  catogoriesNotifier.notifyListeners();
  return categories;
  
}
Future<List<AddProductmodel>> getFilterResults(String clickedCategory) async{
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  final filterResults= productDB.values.where((element) => element.category == clickedCategory).toList();
  return filterResults;
 
}