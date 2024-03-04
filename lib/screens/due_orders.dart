import 'package:flutter/material.dart';
import 'package:rental_app/db/functions/bill_functions.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/no_product.dart';

class DueOrders extends StatelessWidget {
  const DueOrders({super.key});

  @override
  Widget build(BuildContext context) {
    getDueBill();

    return Scaffold(
    //  backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
         backgroundColor: const Color(0xff8ECFCB),
        title: const Center(child: Text('Due orders')),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: dueBillNotifier,
          builder: (BuildContext context, List<BillDetailsModel> duebillList,child){   
            final duebilllist=duebillList.where((data)=>data.isSettled==false);
            if(duebilllist.isNotEmpty){}            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:duebilllist.isNotEmpty? DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns:const [
                    DataColumn(label: Text('Bill No')),
                    DataColumn(label: Text('Return date')),
                    DataColumn(label: Text('Customer name')),
                    DataColumn(label: Text('Total amount')),
                    DataColumn(label: Text('Advance paid')),
                    DataColumn(label: Text('Balance amount')),            
                  ],              
                  rows: duebilllist.map((data) =>  DataRow(cells: [
                   DataCell(Center(child: Text(data.billNo.toString()))),
                   DataCell(Center(child: Text(data.returnDate))),
                   DataCell(Center(child: Text(data.customerName))),
                   DataCell(Center(child: Text((data.advancePaid+data.balanceAmount).toString()))),
                   DataCell(Center(child: Text(data.advancePaid.toString()))),
                   DataCell(Center(child: Text(data.balanceAmount.toString()))),
                               
                  ])).toList(),
                ):
                noProduct(message: 'No Due Orders'),
              ),
            );
            
             
          }),
      ),
    );
  }
  

}