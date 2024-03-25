import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rental_app/db/model/bill_model.dart';

// Future<pw.Font> _loadFont() async {
//  final fontData = await rootBundle.load("assets/fonts/Inspiration-Regular.ttf");
//   final font = pw.Font.ttf(fontData.buffer.asByteData());
//   return font;
// }
pw.Widget buildHeader() {
  return pw.Container(
    
    alignment: pw.Alignment.centerLeft,
    margin: const pw.EdgeInsets.only(bottom: 20.0,left: 20),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('NEW ADDICT BRIDAL JEWELS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: PdfColors.red)),
        pw.SizedBox(height: 5),
        pw.Text('Malappuram', style: const pw.TextStyle(color: PdfColors.red, fontSize: 14)),
        pw.Text('Ph : 8129259002', style: const pw.TextStyle(color: PdfColors.red, fontSize: 14)),
        pw.Text('pin : 676303', style: const pw.TextStyle(color: PdfColors.red, fontSize: 14)),
      ],
    ),
  );
}

pw.Widget buildFooter() {
  return pw.Container(
    alignment: pw.Alignment.center,
    margin: const pw.EdgeInsets.only(bottom: 20.0),
    child: pw.Text('Thanks for your business'),
  );
}
text({required String text}){
 // final newfont= await _loadFont();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 20.0),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
   customerText({required String text}){
 //   final font= await _loadFont();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 20.0),
      child: pw.Text(
        text,
        style:  const pw.TextStyle(
          fontSize: 18.0,
                         
        ),
      ),
    );
  }
buildPdfData(BillDetailsModel billDetailsModel){
 return pw.Container(
  decoration: pw.BoxDecoration(
    border: pw.Border.all(
      color: PdfColors.black,
      width: 1.0,
    )
  ),
   child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 30.0),
      buildHeader(),
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
          pw.Text('Item',textAlign: pw.TextAlign.center),
          pw.Text('Qty',textAlign: pw.TextAlign.center),
          pw.Text('Unit price',textAlign: pw.TextAlign.center),
          pw.Text('Total',textAlign: pw.TextAlign.center),
        ],
      ),
      ...billDetailsModel.cartItems.map((cartItem) {
        return pw.TableRow(
          children: [
            pw.Text(cartItem["name"],textAlign: pw.TextAlign.center),
            pw.Text(cartItem["quantity"].toString(),textAlign: pw.TextAlign.center),
            pw.Text(cartItem["unit_price"].toString(),textAlign: pw.TextAlign.center),
            pw.Text(cartItem["total_price"].toString(),textAlign: pw.TextAlign.center),
          ],
        );
      })
    ],
   ),
      ),
      text(text: 'Total Amount      : ${billDetailsModel.totalAmount}'),
      text(text: 'Advance Paid      : ${billDetailsModel.advancePaid}'),
      text(text: 'Balance Amount : ${billDetailsModel.balanceAmount}'),
      pw.Expanded(child: pw.SizedBox()),
      buildFooter(),
    ],
    
   ),
 );
}
