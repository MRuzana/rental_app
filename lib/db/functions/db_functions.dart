// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:rental_app/db/model/add_product_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:rental_app/db/model/bill_model.dart';
// import 'package:rental_app/db/model/cart_model.dart';
// import 'package:rental_app/db/model/customer_details_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// ValueNotifier<List<AddProductmodel>>productListNotifier=ValueNotifier([]);
// ValueNotifier<List<String>>catogoriesNotifier=ValueNotifier([]);
// ValueNotifier<int>cartItemCountNotifier=ValueNotifier<int>(0);
// ValueNotifier<List<CartModel>>cartItemListNotifier=ValueNotifier([]);
// ValueNotifier<List<BillDetailsModel>>billListNotifier=ValueNotifier([]);
// ValueNotifier<List<BillDetailsModel>>dueBillNotifier=ValueNotifier([]);


// Future <void> addProduct(AddProductmodel value)async{
//   final productDB=await Hive.openBox<AddProductmodel>('product_db');
//   final id = await productDB.add(value);
//   value.id = id;
//    await productDB.put(value.id,value);
//   //productListNotifier.value.add(value);
//   productListNotifier.notifyListeners();
//  // await productDB.close();
// }
// Future <void>getAllProducts()async{
//   final productDB=await Hive.openBox<AddProductmodel>('product_db');
//   print('Product List: ${productDB.values.toList()}');
//   productListNotifier.value.clear();
//   productListNotifier.value.addAll(productDB.values);
//   productListNotifier.notifyListeners();
// }

// Future<void>deleteProduct(int id)async{
  
//   final productDB=await Hive.openBox<AddProductmodel>('product_db');
//   final cartDB=await Hive.openBox<CartModel>('cart_db');
//   await productDB.delete(id);

//   if(isItemInCart(id)){
//     await cartDB.delete(id);
//   }
//   await getAllProducts();
//   await getCategory();
//   getAllCartItems();

//   productListNotifier.notifyListeners();
//   catogoriesNotifier.notifyListeners();
//   cartItemListNotifier.notifyListeners();

// }
// Future<void>editProduct(updatedProduct,id)async{
//    final productDB=await Hive.openBox<AddProductmodel>('product_db');
//    await productDB.put(updatedProduct.id,updatedProduct);
// }

// Future<List<String>>getCategory()async{
//   final productDB=await Hive.openBox<AddProductmodel>('product_db');
//   final categories = productDB.values.map((category) => category.category).toSet().toList();
//   catogoriesNotifier.value.clear();
//   catogoriesNotifier.value.addAll(categories);
//   catogoriesNotifier.notifyListeners();
//   return categories;
  
// }
// Future<List<AddProductmodel>> getFilterResults(String clickedCategory) async{
//   final productDB=await Hive.openBox<AddProductmodel>('product_db');
//   final filterResults= productDB.values.where((element) => element.category == clickedCategory).toList();
//   return filterResults;
 
// }

// Future <void>getCustomerDetails()async{
//   final customerDB=await Hive.openBox<CustomerDetailsModel>('customerDetails_db');
// }

// bool isItemInCart(int itemId) {

//   for (final cartItem in cartItemListNotifier.value) {  
//     if (cartItem.id== itemId) {
//       return true; // Item is already in the cart
//     }
//   }
//   return false; // Item is not in the cart
// }

// Future <void> addToCart(CartModel value)async{
//    final cartDB=await Hive.openBox<CartModel>('cart_db');
   
//    final cartId=await cartDB.add(value);
//    value.cartId=cartId;
//    await cartDB.put(value.cartId,value);
//    cartItemListNotifier.value.add(value);
//    cartItemCountNotifier.value++;
//    cartItemListNotifier.notifyListeners();
//    cartItemCountNotifier.notifyListeners();
//   }

// Future<void>getAllCartItems()async{
//   final cartDB=await Hive.openBox<CartModel>('cart_db');
//    print('cart List: ${cartDB.values.toList()}');
//   cartItemListNotifier.value.clear();
//   cartItemListNotifier.value.addAll(cartDB.values);
//   cartItemListNotifier.notifyListeners();
// }

// Future<void>deleteCartItem(int cartid)async{

//   final cartDB=await Hive.openBox<CartModel>('cart_db');
//   await cartDB.delete(cartid);
//   await getAllCartItems();
//   if(cartItemCountNotifier.value>0){
//     cartItemCountNotifier.value--;
//   }
//   cartItemListNotifier.notifyListeners();
//   cartItemCountNotifier.notifyListeners();   
// }

// void clearCart()async{
//   final cartDB=await Hive.openBox<CartModel>('cart_db');
//   await cartDB.clear();
//   cartItemListNotifier.value.clear();
//   cartItemCountNotifier.value = 0;

//   cartItemListNotifier.notifyListeners();
//   cartItemCountNotifier.notifyListeners();
// }

// Future <void>addBill(BillDetailsModel value)async{
//   final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
//   final booking_id=await billDB.add(value);
//   value.bookingId=booking_id;

//   SharedPreferences sharedPrefs=await SharedPreferences.getInstance();
//   int currentBillNo=sharedPrefs.getInt('currentBillNo')?? 1;
//   int nextBillNo=currentBillNo+1;
//   await sharedPrefs.setInt('currentBillNo', nextBillNo);
// }

// Future<int>nextBillNo()async{
//   SharedPreferences sharedPrefs=await SharedPreferences.getInstance();
//   int currentBillNo=sharedPrefs.getInt('currentBillNo')?? 1;
//   // int nextBillNo=currentBillNo+1;
//   // await sharedPrefs.setInt('currentBillNo', nextBillNo);
//   return currentBillNo;
// }
       
// Future <void>getBillDetails()async{
//   final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
//   print('bill Details: ${billDB.values.toList()}');
//   billListNotifier.value.clear();
//   billListNotifier.value.addAll(billDB.values);
//   billListNotifier.notifyListeners();
// }

// Future<void>updateBill(int settledBillNo,billingDate,clickedBillIndex)async{

//   final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
//   final bill=billDB.values.elementAt(clickedBillIndex);
//   if(bill.billNo==settledBillNo){
//     bill.isSettled=true;
//     bill.billingDate=billingDate;
//     await billDB.put(clickedBillIndex, bill);
//   }  
// }

// Future<void>getDueBill()async{
//   final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
//   final currentDate=DateTime.now();
//   final dueBills=billDB.values.where((bill) =>  DateFormat('dd-MM-yyyy').parse(bill.returnDate).
//   isBefore(currentDate)|| DateFormat('dd-MM-yyyy').parse(bill.returnDate)==currentDate) ;
//   print('duebills${dueBills.toList()}');
//   dueBillNotifier.value.clear();
//   dueBillNotifier.value.addAll(dueBills);
//   dueBillNotifier.notifyListeners();
// }

// Future<List<BillDetailsModel>>searchText(String searchText)async{
//   print('search $searchText');
//   final productDB= await Hive.openBox<BillDetailsModel>('bill_db');
  
//     int? searched_billNo=int.tryParse(searchText.trim());
//     final results=productDB.values
//     .where((product) =>
    
//     product.customerName.contains(searchText)||
//     product.customerMobileNo.contains(searchText)
//    ).toList();
   
//     return results;
  
//   }
//   Future<Iterable<BillDetailsModel>>getSettledBill()async{
//     final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
//     final settledBills=billDB.values.where((element) => element.isSettled==true);
//     print('settled bills are : $settledBills');
//     return settledBills;
//   }


  



   
