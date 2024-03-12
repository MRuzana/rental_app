import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/widget/printable_data.dart';
import 'package:share_plus/share_plus.dart';

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
        backgroundColor: const Color.fromARGB(255, 206, 242, 242),    
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(text: 'Date : ${billDetailsModel.billingDate}'),
                      IconButton(onPressed: (){
                        printDoc();
                      }, icon: const Icon(Icons.picture_as_pdf,color: Colors.red,))
                    ],
                  ),
                                  
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

  Future<void>printDoc()async{
    final doc=pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildprintable_data(billDetailsModel);
    },));
    final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final String fullPath = '$appDocPath/bill${billDetailsModel.billNo}.pdf';
  final File file = File(fullPath);
  await file.writeAsBytes(await doc.save());

  // Share the PDF file via WhatsApp
  Share.shareFiles([fullPath], text: 'Check out this bill');

  // Share the PDF file via WhatsApp
 // Share.shareFiles(['example.pdf'], text: 'Check out this bill');
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async =>doc.save());
  }
}

