// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_app/db/model/cart_model.dart';

ValueNotifier<int>cartItemCountNotifier=ValueNotifier<int>(0);
ValueNotifier<List<CartModel>>cartItemListNotifier=ValueNotifier([]);

Future <void> addToCart(CartModel value)async{
  try{
  
    final cartDB= await Hive.openBox<CartModel>('cart_db');
    final cartId=await cartDB.add(value);
    value.cartId=cartId;
    await cartDB.put(value.cartId,value);
  // cartItemListNotifier.value.add(value);
    cartItemCountNotifier.value++;
    cartItemListNotifier.notifyListeners();
    cartItemCountNotifier.notifyListeners();
    getAllCartItems();
  }
  catch(error){
    print(error);
  }
     

  
  }

Future<void>getAllCartItems()async{
  final cartDB=await Hive.openBox<CartModel>('cart_db');
  cartItemListNotifier.value.clear();
  cartItemListNotifier.value.addAll(cartDB.values);
  cartItemListNotifier.notifyListeners();
}

bool isItemInCart(int itemId) {

  for (final cartItem in cartItemListNotifier.value) { 
    if (cartItem.id== itemId) {
      return true; 
    }
  }
  return false; 
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
