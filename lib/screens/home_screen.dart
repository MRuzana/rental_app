import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

Widget slider({required ImageProvider image}){
  return Container(    
    decoration: BoxDecoration(    
    image: DecorationImage( 
      image: image, 
      fit: BoxFit.cover, 
    ),), 
  );
}

  @override
  Widget build(BuildContext context) {
     getAllProducts();
     getCategory();
    return Scaffold(
     // backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB), 
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Menu()));  
          },
          icon: const Icon(Icons.menu,color: Colors.black,)),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
                },
                icon: const Icon(Icons.shopping_cart,color: Colors.black,),),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Badge(
                    backgroundColor: Colors.red,
                    label: ValueListenableBuilder<int>(
                      valueListenable: cartItemCountNotifier,
                      builder: (context,count,_){
                        return Text('$count');
                      }),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: IconButton(
                  onPressed: (){
                    selectedCategoryNotifier.value=null;
                    getAllProducts();
                    
                  },
                  icon:const Icon(Icons.refresh,color: Colors.black,)),
              )  
            ],
          )
        ],  
      ),

      body: SafeArea(
        child: ListView(
          children: [
            CarouselSlider( 
              items: [ 
                //  slider(image: const NetworkImage("https://www.josalukkasonline.com/Media/CMS/jos-alukkas-wedding-20231208145835676216.webp")), 
                  slider(image: const NetworkImage("https://fashiondeal.in/image/cache/catalog/Calf-Jewels/twinkling-fancy-jewellery-sets-9859-600x800h.jpg")),
                  slider(image: const NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnuBRgF_Umoe1rdD8mjwveXk-Tr90cHvYz-w&usqp=CAU")),
                  slider(image: const NetworkImage("https://img.freepik.com/free-psd/women-s-fashion-design-template_23-2150877185.jpg?size=626&ext=jpg&ga=GA1.1.1413502914.1708646400&semt=ais")),
                  slider(image: const NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTK1bbkv0xretXDJRZ2K0Uik0gEvosJJxUJ9Mo0nIL-XZ_1MVSz8erMj8h8dOyTp3Spkg&usqp=CAU")),                   
              ],                    
              options: CarouselOptions( 
                height: 180.0, 
                enlargeCenterPage: true, 
                autoPlay: true, 
                aspectRatio: 16 / 9, 
                autoPlayCurve: Curves.fastOutSlowIn, 
                enableInfiniteScroll: true, 
                autoPlayAnimationDuration: const Duration(milliseconds: 800), 
                viewportFraction: 1.0, 
              ), 
          ), 
           
            category(),

            ValueListenableBuilder(
              valueListenable: productListNotifier,
              builder: (BuildContext ctx, List<AddProductmodel> productList, Widget? child){
                if(productList.isEmpty){
                  return noProduct(message: 'No Product');
                }
                else{
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      final data=productList[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0 ),
                        child: Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 251, 251), 
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(                          
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.memory(File(data.imagePath).readAsBytesSync(),
                                     fit: BoxFit.cover,),
                                  ),
                                ),
                                
                                const SizedBox(width: 10.0),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 80.0,
                                      child: Text(data.name,overflow: TextOverflow.ellipsis,maxLines: 1,),                                  
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      width: 80.0,
                                      child: Text('₹${data.price}',overflow: TextOverflow.ellipsis,maxLines: 1,),                                  
                                    ),
                                    const SizedBox(
                                      width: 80.0,
                                      child: Text('In stock',style: TextStyle(color: Color.fromARGB(255, 11, 213, 18),fontWeight: FontWeight.bold),)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 60.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if(data.id !=null){
                                            editAlert(context,data.id!,productList,index);
                                          }
                                        },
                                        child: const Icon(Icons.edit,color:Color.fromARGB(255, 11, 213, 18) ,)
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if(data.id !=null){
                                            deleteAlert(context,data.id!);
                                          }
                                        },
                                        child: const Icon(Icons.delete,color: Colors.red,)
                                      ),
                            
                                      GestureDetector(
                                        onTap: () async {
                                          final data=productList[index]; 
                                          print('home id ${data.id}');
                            
                                          if(isItemInCart(data.id!)){
                                            ScaffoldMessenger.of(context).showSnackBar(                                      
                                            const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Color(0xff8ECFCB),
                                            margin: EdgeInsets.all(10),
                                            content: Text('Item Already added',style: TextStyle(
                                            color: Colors.black
                                            ),)));
                                          }
                                          else{
                                            final cartProduct=CartModel(name: data.name, price: data.price, category: data.category, details: data.details, imagePath: data.imagePath,quantity: 1,id: data.id!);                                                                
                                            addToCart(cartProduct);
                                          }  
                                        },
                                        child: const Center(
                                          child: Text('Add to cart',style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            
                              ],
                            ),
                          ),
                          
                        ),
                      );

                    },
                    itemCount: productList.length,
                  );
                }
              }           
            )
          ],      
        ),   
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddProduct()));
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff8ECFCB),
        child: const Icon(Icons.add),
      ),      
    );
  }
}
editAlert(BuildContext context,int id,List<AddProductmodel> productList,int index){
  showDialog(
    context: context,
    builder: (context){
      return EditAlert(
        onEdit: (){
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProduct(addProductModel: productList[index])));             
        }
      );
    });
}

deleteAlert(BuildContext context,int id){
  showDialog(
    context: context,
    builder: (context){
      return DeleteAlert(
        onDelete: (){
          deleteProduct(id);
          Navigator.of(context).pop();
        });
    });
}




