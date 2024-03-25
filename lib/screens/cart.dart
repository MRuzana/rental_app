// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/screens/customer_info.dart';
import 'package:rental_app/db/model/cart_model.dart';

class Cart extends StatelessWidget {
  Cart({super.key});

  final ValueNotifier<int> totalQuantityNotifier = ValueNotifier<int>(0);
  final ValueNotifier<double> totalSumNotifier = ValueNotifier<double>(0);
  final List<String> cartItemNames = [];
  @override
  Widget build(BuildContext context) {
    getAllCartItems();

    return Scaffold(
      //backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 242, 242),    
        title: const Center(child: Text('Cart')),
      ),

      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: cartItemListNotifier,
                      builder:
                          (BuildContext context, cartItemList, Widget? child) {
                        double total = 0;
                        double itemTotalPrice;
                        double sum = 0;                       
                        totalQuantityNotifier.value = calculateTotalQuantity(cartItemList);
                        totalSumNotifier.value = calculateTotalSum(cartItemList);                          

                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = cartItemList[index];
                              itemTotalPrice = total + (data.quantity! * int.parse(data.price));
                              sum = sum + itemTotalPrice;
                              int updatedStock=data.itemStock-data.quantity!;
                              
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 135.0 ,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 195, 247, 247), 
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: ListTile(
                                      title: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 80.0,
                                                height: 80.0,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: kIsWeb?
                                                  Image.network(data.imagePath,fit: BoxFit.cover,):
                                                  
                                                  Image.memory(
                                                    File(data.imagePath).readAsBytesSync(),
                                                    fit: BoxFit.cover,
                                                    ),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.name), 
                                                  const SizedBox(height: 5.0),                                              
                                                  Text('₹${data.price}'),                                                  
                                                  Text( '₹$itemTotalPrice',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                           Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (cartItemList[index] .quantity! > 1) {
                                                cartItemList[index].quantity = cartItemList[index].quantity! - 1;
                                                cartItemListNotifier.notifyListeners();                                               
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.remove_circle,color: Colors.black,),
                                          ),
                                          Text(data.quantity.toString(),style: const TextStyle(color: Colors.black),),
                                          IconButton(
                                            onPressed: () {                                              
                                              if(updatedStock>0){
                                              cartItemList[index].quantity = cartItemList[index].quantity! + 1;
                                              cartItemListNotifier.notifyListeners();
                                              }
                                              else{
                                                 ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.red,
                                                    margin: EdgeInsets.all(10),
                                                    content: Text(
                                                      'Out of Stock',
                                                      style: TextStyle( color: Colors.white),
                                                    ),
                                                  ));
                                              }
                                            },
                                            icon: const Icon(Icons.add_circle,color: Colors.black),
                                          ),   
                                        ],
                                      ),
                                      ],
                                    ),
                                      trailing: Column(
                                        children: [
                                          Text('$updatedStock items left',style: const TextStyle(fontSize: 12,color: Colors.red ),),

                                          Expanded(
                                            child: IconButton(
                                              onPressed: () {
                                               
                                                deleteCartItem(data.cartId!);
                                                totalQuantityNotifier.value=totalQuantityNotifier.value-data.quantity!;
                                                totalSumNotifier.value=totalSumNotifier.value-data.quantity! * double.parse(data.price);
                                                totalQuantityNotifier.notifyListeners();
                                                totalSumNotifier.notifyListeners();
                                              },
                                              icon: const Icon( Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: cartItemList.length
                          ); 
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              height: 140.0,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 206, 242, 242),    
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: totalQuantityNotifier,
                      builder: (BuildContext context, int totalQuantity,
                          Widget? child) {
                        return Text('$totalQuantity items in cart',
                          style: const TextStyle(fontSize: 18.0),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: totalSumNotifier,
                      builder: (context, sum, child) {
                        return Text('Sub total price : ₹$sum',
                          style: const TextStyle(fontSize: 18.0),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffC8B6B6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              List<Map<String, dynamic>> stockInfoList = createStockInfo(cartItemListNotifier.value);
                              
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CustomerInfo(
                                        cartItems: cartItemListNotifier.value,
                                        sum: totalSumNotifier.value,
                                        stockInfo: stockInfoList,
                                      )));
                            },
                            child: const Center(
                              child: Text(
                                'BOOK NOW ',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),                                                                              
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  int calculateTotalQuantity(List<CartModel> cartItemList) {
    int totalQuantity = 0;
    for (final item in cartItemList) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        totalQuantity = totalQuantity + item.quantity!;
        totalQuantityNotifier.value = totalQuantity;
        totalQuantityNotifier.notifyListeners();
      });
    }

    return totalQuantityNotifier.value;
  }

  double calculateTotalSum(List<CartModel> cartItemList) {
    double sum = 0;
    for (final item in cartItemList) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        sum = sum + (item.quantity! * double.parse(item.price));
        totalSumNotifier.value = sum;
        totalSumNotifier.notifyListeners();
      });
    }
    return totalSumNotifier.value;
  }

  createStockInfo(List<CartModel>cartitems){
    List<Map<String,dynamic>>stockInfo=[];
    for(var items in cartitems){
      int updatedStock=items.itemStock-items.quantity!;
      Map<String,dynamic>itemInfo={
        'id':items.id,
        'itemName':items.name,
        'updatedStock':updatedStock,
      };
      stockInfo.add(itemInfo);
    }
    return stockInfo;
  }
}
