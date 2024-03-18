import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/build_pdf_data.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<void> sharePdf(BillDetailsModel billDetailsModel) async {
  try {
   final pw.Document doc = pw.Document();
   pdf.PdfDocument pdfDocument = pdf.PdfDocument();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPdfData(billDetailsModel);
      },
    ),
  );
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final String fullPath = '$appDocPath/bill${billDetailsModel.billNo}.pdf';
  final file = File(fullPath);

  await file.writeAsBytes(await doc.save());
  print('PDF generated successfully at: $fullPath');

    final email = Email(
      recipients: [billDetailsModel.customerMail!],
      subject: 'Bill Details',
      body: 'Please find the attached PDF file for bill details.',
      attachmentPaths: [fullPath],
    );

    await FlutterEmailSender.send(email);
    print('Email sent successfully.');
  } catch (error) {
    print('Error generating or sharing PDF: $error');
   
   }
}

