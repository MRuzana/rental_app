import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_app/db/model/cart_model.dart';

ValueNotifier<int>cartItemCountNotifier=ValueNotifier<int>(0);
ValueNotifier<List<CartModel>>cartItemListNotifier=ValueNotifier([]);

Future <void> addToCart(CartModel value)async{
   final cartDB=await Hive.openBox<CartModel>('cart_db');
   
   final cartId=await cartDB.add(value);
   value.cartId=cartId;
   await cartDB.put(value.cartId,value);
  // cartItemListNotifier.value.add(value);
   cartItemCountNotifier.value++;
   cartItemListNotifier.notifyListeners();
   cartItemCountNotifier.notifyListeners();
  }

Future<void>getAllCartItems()async{
  final cartDB=await Hive.openBox<CartModel>('cart_db');
   print('cart List: ${cartDB.values.toList()}');
  cartItemListNotifier.value.clear();
  cartItemListNotifier.value.addAll(cartDB.values);
  cartItemListNotifier.notifyListeners();
}

bool isItemInCart(int itemId) {

  for (final cartItem in cartItemListNotifier.value) {  
    if (cartItem.id== itemId) {
      return true; // Item is already in the cart
    }
  }
  return false; // Item is not in the cart
}
Future<void>deleteCartItem(int cartid)async{

  final cartDB=await Hive.openBox<CartModel>('cart_db');
  await cartDB.delete(cartid);
  await getAllCartItems();
  if(cartItemCountNotifier.value>0){
    cartItemCountNotifier.value--;
  }
  cartItemListNotifier.notifyListeners();
  cartItemCountNotifier.notifyListeners();   
}

void clearCart()async{
  final cartDB=await Hive.openBox<CartModel>('cart_db');
  await cartDB.clear();
  cartItemListNotifier.value.clear();
  cartItemCountNotifier.value = 0;

  cartItemListNotifier.notifyListeners();
  cartItemCountNotifier.notifyListeners();
}