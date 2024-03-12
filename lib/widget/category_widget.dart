import 'package:flutter/material.dart';
import 'package:rental_app/db/functions/product_fuctions.dart';
import 'package:rental_app/db/model/add_product_model.dart';

final selectedCategoryNotifier = ValueNotifier<String?>(null);

Widget category() {
   
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
    child: SizedBox(
      height: 50,
      child: ValueListenableBuilder(
        valueListenable: catogoriesNotifier,
        builder: (context, category, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ValueListenableBuilder(
                  valueListenable: selectedCategoryNotifier,
                  builder: (BuildContext context, selected , child){
                    return Container(
                      width: 100,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), 
                        color: selectedCategoryNotifier.value==category[index]? const Color.fromARGB(255, 155, 154, 154) : const Color.fromARGB(255, 206, 242, 242) ,  
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: ()async{
                            String clickedCategory = category[index];
                            selectedCategoryNotifier.value=clickedCategory; 
                            List<AddProductmodel> productList =
                               await getFilterResults(clickedCategory);
                           print('the result $productList'); 
                           productListNotifier.value = productList;        
                          },
                          child: Text(category.isNotEmpty ? category[index] : '',
                          style: const TextStyle(fontSize: 20, ),),
                          

                        ),
                      ),
                    );
                  },                
                ),
              );
            },
            itemCount: category.length,
          );
        },
      ),
    ),
  );
}

