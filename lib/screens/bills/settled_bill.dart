import 'package:flutter/material.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/screens/home_screen.dart';

class BillSettled extends StatelessWidget {
  final BillDetailsModel billDetailsModel;
  const BillSettled({super.key,required this.billDetailsModel});

  Widget text({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget customerText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Text('Bills'),
        leading: 
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          }, icon: const Icon(Icons.arrow_back))
        ,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0),
                  text(text: 'Date : ${billDetailsModel.billingDate}'),
                 // text(text: 'Issettledd ${billDetailsModel.isSettled}'),
                  text(text: 'Bill No : ${billDetailsModel.billNo}'),
                  const SizedBox( height: 20.0 ),
                  text(text: 'Customer details'),
                  const SizedBox(height: 10.0,),
                  customerText(text: 'Name          : ${billDetailsModel.customerName}'),
                  customerText(text: 'Address      : ${billDetailsModel.customerAddress}'),
                  customerText(text: 'Place           : ${billDetailsModel.customerPlace}'),
                  customerText(text: 'Mobile no    : ${billDetailsModel.customerMobileNo}'),
                  customerText(text: 'Event date   : ${billDetailsModel.eventDate}'),
                  customerText(text: 'Return date : ${billDetailsModel.returnDate}'),
                  const SizedBox(height: 20.0,), 
                   text(text: 'Item details'), 
                  Padding(
                    padding: const EdgeInsets.all(12.0 ),
                      child: DataTable(
                        border: TableBorder.all(color: Colors.black),
                          columns: const [
                            DataColumn(label: Expanded(child: Text('Item')),),
                            DataColumn(label: Expanded(child: Text('Qty '))),
                            DataColumn(label: Expanded(child: Text('Unit price',overflow: TextOverflow.ellipsis,maxLines: 2,))),
                            DataColumn(label: Expanded(child: Text('Total'))),
                          ],
                          rows: billDetailsModel.cartItems.map((cartItem) {                                                                                    
                            return DataRow(                   
                            cells: [                    
                              DataCell(Text(cartItem["name"])),
                              DataCell(Text(cartItem["quantity"].toString())),
                              DataCell(Text(cartItem["unit_price"].toString())),
                              DataCell(Text(cartItem["total_price"].toString())),
                
                            ]);
                          }).toList(),
                        ),
                   ),
                  text(text: 'Total Amount      : ${billDetailsModel.totalAmount}'),
                  text(text: 'Advance Paid      : ${billDetailsModel.advancePaid}'),
                  text(text: 'Balance Amount : ${billDetailsModel.balanceAmount}'),                     
                ],                 
              )
      )),
    );
  }
}