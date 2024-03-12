import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rental_app/db/model/bill_model.dart';

pw.Widget text({required String text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 20.0),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
  pw.Widget customerText({required String text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 20.0),
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
buildprintable_data(BillDetailsModel billDetailsModel)=>
 pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [
    pw.SizedBox(height: 30.0),
    text(text: 'Date : ${billDetailsModel.billingDate}'),
    text(text: 'Bill No : ${billDetailsModel.billNo}'),
    pw.SizedBox(height: 20.0),
    text(text: 'Customer details'),
    pw.SizedBox(height: 10.0,),
    customerText(text: 'Name          : ${billDetailsModel.customerName}'),
    customerText(text: 'Address      : ${billDetailsModel.customerAddress}'),
    customerText(text: 'Place           : ${billDetailsModel.customerPlace}'),
    customerText(text: 'Mobile no    : ${billDetailsModel.customerMobileNo}'),
    customerText(text: 'Event date   : ${billDetailsModel.eventDate}'),
    customerText(text: 'Return date : ${billDetailsModel.returnDate}'),
    pw.SizedBox(height: 20.0,),
    text(text: 'Item details'),
    pw.Padding(
      padding: const pw.EdgeInsets.all(12.0),
     child: pw.Table(
  border: pw.TableBorder.all(color: PdfColors.black),
  columnWidths: {
    0: const pw.FlexColumnWidth(3), // Adjust the width of the columns as needed
    1: const pw.FlexColumnWidth(1),
    2: const pw.FlexColumnWidth(2),
    3: const pw.FlexColumnWidth(2),
  },
  children: [
    pw.TableRow(
      children: [
        pw.Text('Item'),
        pw.Text('Qty'),
        pw.Text('Unit price'),
        pw.Text('Total'),
      ],
    ),
    ...billDetailsModel.cartItems.map((cartItem) {
      return pw.TableRow(
        children: [
          pw.Text(cartItem["name"]),
          pw.Text(cartItem["quantity"].toString()),
          pw.Text(cartItem["unit_price"].toString()),
          pw.Text(cartItem["total_price"].toString()),
        ],
      );
    }).toList(),
  ],
),
    ),
    text(text: 'Total Amount      : ${billDetailsModel.totalAmount}'),
    text(text: 'Advance Paid      : ${billDetailsModel.advancePaid}'),
    text(text: 'Balance Amount : ${billDetailsModel.balanceAmount}'),
   // text(text: 'Balance Amount received and bill settled',sty),
  ],
);

