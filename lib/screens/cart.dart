import 'dart:io';
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
        backgroundColor: const Color(0xff8ECFCB),
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

                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 125,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: ListTile(
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 80.0,
                                            height: 80.0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.memory(
                                                File(data.imagePath)
                                                    .readAsBytesSync(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(data.id.toString()),
                                                const SizedBox(height: 5.0),                                              
                                                Text('₹${data.price}'),
                                                Text( '₹$itemTotalPrice',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
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
                                                const Icon(Icons.remove_circle),
                                          ),
                                          Text(data.quantity.toString()),
                                          IconButton(
                                            onPressed: () {
                                              cartItemList[index].quantity = cartItemList[index].quantity! +                                                     1;
                                              cartItemListNotifier.notifyListeners();
                                            },
                                            icon: const Icon(Icons.add_circle),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              print('data.id${data.cartId!}');
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
                  color: const Color(0xff8ECFCB),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CustomerInfo(
                                        cartItems: cartItemListNotifier.value,
                                        sum: totalSumNotifier.value,
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
}
