import 'package:flutter/material.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/no_product.dart';
import 'package:rental_app/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DueOrders extends StatelessWidget {
  const DueOrders({super.key});

  @override
  Widget build(BuildContext context) {
    getDueBill();

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 195, 247, 247), 
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 195, 247, 247), 
        title: const Center(child: Text('Due orders')),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: dueBillNotifier,
          builder: (BuildContext context, List<BillDetailsModel> duebillList,child){  
            if(duebillList.isEmpty){
              return noProduct(message:'No Due Orders');
            }
            else{                       
              return ListView.builder(
                itemBuilder: (context,index){
                  final data=duebillList[index];
                
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                        child: Card(
                          color: const Color.fromARGB(255, 195, 247, 247),                 
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20.0),
                            leading: IconButton(onPressed: ()async{
                         Uri url = Uri.parse('tel:+91${data.customerMobileNo}');
                        if (await launchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }, icon: const Icon(Icons.phone,color: Colors.green,)),
                      title: textfield(
                        text: 'Bill no : ${data.billNo}', 
                        color:  Colors.black,
                        size: 16, 
                        weight: FontWeight.bold),
                                    
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5.0),
                          textfield(text: 'Name : ${data.customerName}', color: Colors.black, size: 15, weight: FontWeight.bold),            
                          const SizedBox(height: 5.0),
                          textfield(text: 'Return date : ${data.returnDate}', color: Colors.red, size: 14, weight: FontWeight.normal),                       
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: textfield(text: 'Tot amt : ${data.totalAmount}', color: Colors.black, size: 12, weight: FontWeight.bold)),
                            textfield(text: 'Adv paid : ${data.advancePaid}', color: Colors.black, size: 12, weight: FontWeight.bold),
                            textfield(text: 'Bal amt : ${data.balanceAmount}', color: Colors.red, size: 12, weight: FontWeight.bold ),             
                          ],
                      ),
                    ),
                  ),
                ); 
                                            
              },
              itemCount: duebillList.length,
            );
          }
        }),
      ),
    );
  }  
}