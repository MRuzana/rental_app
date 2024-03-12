// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/db/model/cart_model.dart';

ValueNotifier<List<AddProductmodel>>productListNotifier=ValueNotifier([]);
ValueNotifier<List<String>>catogoriesNotifier=ValueNotifier([]);

Future <void> addProduct(AddProductmodel value)async{
  final productDB=await Hive.openBox<AddProductmodel>('product_db');
  final productid = await productDB.add(value);
  value.id = productid;
  await productDB.put(value.id,value);
  productListNotifier.notifyListeners();
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

  CartModel? isItemCart(int id) {
    for (final cartItem in cartItemListNotifier.value) {
      if (cartItem.id == id) {
        return cartItem; // Return the cart item object
      }
    }
      return null; // Return null if not found
  }
final item=isItemCart(id);
print('item is $item');
if(item!=null){
  await deleteCartItem(item.cartId!);
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