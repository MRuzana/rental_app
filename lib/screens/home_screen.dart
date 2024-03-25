import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/functions/cart_functions.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/screens/add_product.dart';
import 'package:rental_app/screens/edit_product.dart';
import 'package:rental_app/screens/cart.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/db/model/cart_model.dart';
import 'package:rental_app/screens/menu.dart';
import 'package:rental_app/widget/category_widget.dart';
import 'package:rental_app/widget/delete_widget.dart';
import 'package:rental_app/widget/edit_widget.dart';
import 'package:rental_app/widget/no_product.dart';
import 'package:rental_app/widget/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int>stockNotifier=ValueNotifier<int>(0);

  Widget slider({required ImageProvider image}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getAllProducts();
    getCategory();
    getAllCartItems();

    return Scaffold(    
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 247, 247), 
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Menu()));
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Badge(
                  backgroundColor: Colors.red,
                  label: ValueListenableBuilder<int>(
                      valueListenable: cartItemCountNotifier,
                      builder: (context, count, _) {
                        return Text('$count');
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: IconButton(
                    onPressed: () {
                      selectedCategoryNotifier.value = null;
                      getAllProducts();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                    )),
              )
            ],
          )
        ],
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0 ),
              child: ListView(
                children: [
                  CarouselSlider(
                    items: [
                      slider(image: const AssetImage("assets/images/slider1.jpg")),
                      slider(image: const AssetImage("assets/images/slider2.jpeg")),
                      slider(image: const AssetImage("assets/images/slider3.jpeg")),
                      slider(image: const AssetImage("assets/images/slider4.jpeg")),
                      slider(image: const AssetImage("assets/images/slider5.jpeg")),
                     
                    ],
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                  ),
                  
                  category(),
                  ValueListenableBuilder(
                      valueListenable: productListNotifier,
                      builder: (BuildContext ctx,
                          List<AddProductmodel> productList, Widget? child) {
                        if (productList.isEmpty) {
                          return noProduct(message: 'No Product');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = productList[index];
                             
              
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 214, 251, 251),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      
                                      SizedBox(width: 100,height: 100,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          child: !kIsWeb?                                                                                  
                                          Image.memory(
                                            File(data.imagePath).readAsBytesSync(),
                                            fit: BoxFit.cover,
                                          ):
                                           Image.network(data.imagePath,fit: BoxFit.cover,),   
                                                                                                                                                             
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            textfield(
                                              text: data.name, 
                                              color: Colors.black, 
                                              size: 18,
                                              weight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,                                                                                       
                                            ),                                         
                                            const SizedBox(height: 5),
                                            textfield(
                                              text: '₹${data.price}',
                                              color: Colors.black, 
                                              size: 16, 
                                              weight: FontWeight.normal,
                                              overflow: TextOverflow.ellipsis,
                                            ),                                         
                                            const SizedBox(height: 5),
                                            ValueListenableBuilder(
                                              valueListenable: stockNotifier, 
                                              builder: (BuildContext context, stockNumber, child){
                                                final bool isOutOfStock = data.stockNumber == 0;
                                                final Color textColor = isOutOfStock ? Colors.red : Colors.green;
                                                final String text = isOutOfStock ? 'Out of Stock' : 'In Stock';
                                                return textfield(
                                                  text: text, 
                                                  color: textColor, 
                                                  size: 15, 
                                                  weight: FontWeight.bold,);
                                              })  
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (data.id != null) {
                                                editAlert(context, data.id!,
                                                    productList, index);
                                              }
                                            },
                                            child: const Icon(Icons.edit,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () {
                                              if (data.id != null) {
                                                deleteAlert(context, data.id!);
                                              }
                                            },
                                            child: const Icon(Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              final data = productList[index];
                                              if(data.stockNumber==0){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.red,
                                                    margin: EdgeInsets.all(10),
                                                    content: Text('Out of Stock',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
              
                                              }
                                              else{
                                                if (isItemInCart(data.id!)) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.red,
                                                    margin: EdgeInsets.all(10),
                                                    content: Text('Item Already added',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              
                                              } else {
                                                final cartProduct = CartModel(
                                                  name: data.name,
                                                  price: data.price,
                                                  category: data.category,
                                                  details: data.details,
                                                  imagePath: data.imagePath,
                                                  itemStock: data.stockNumber,
                                                  quantity: 1,
                                                  id: data.id!,
                                                );
                                                addToCart(cartProduct);
              
                                                final formattedDate = DateFormat('MMM d, yyyy').format(DateTime.now());
              
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.green,
                                                    margin: const EdgeInsets.all(10),
                                                    content: Text(
                                                      'Item added to cart on $formattedDate',
                                                      style: const TextStyle( color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }                                                                                           
                                                                               
                                            },
                                            child: textfield(
                                              text: 'Add to cart',
                                              color: Colors.black,
                                              size: 14, 
                                              weight: FontWeight.bold,),                                         
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 30),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: productList.length,
                          );
                        }
                      }),
                ],
              ),
            ),

           
            Positioned(
              
              bottom: 16.0,
             // right: 16.0,
              left: MediaQuery.of(context).size.width / 2 ,
              child: Center(
                child: FloatingActionButton.small(
                  
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AddProduct()));
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 206, 242, 242),    
                  child: const Icon(Icons.add),
                  
                ),
              ),
              
            )
          ],
        ),
      ),
    );
  }
}

editAlert(BuildContext context, int id, List<AddProductmodel> productList,
    int index) {
  showDialog(
      context: context,
      builder: (context) {
        return EditAlert(onEdit: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditProduct(addProductModel: productList[index])));
        });
      });
}

deleteAlert(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (context) {
        return DeleteAlert(onDelete: () {
          deleteProduct(id);
          Navigator.of(context).pop();
        });
      });
}
