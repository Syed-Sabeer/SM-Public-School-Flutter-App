import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FeeVoucherScreen extends StatelessWidget {
  const FeeVoucherScreen({Key? key}) : super(key: key);

  // Function to generate the PDF
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // Adding content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Fee Voucher',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),

                // Voucher Details
                pw.Text('Name: John Doe'),
                pw.Text('ID Number: 123456'),
                pw.Text('Class: 10th Grade'),
                pw.Text('Due Date: 2024-06-15'),
                pw.Text('Amount: \$500'),
                pw.SizedBox(height: 20),

                pw.Divider(),

                pw.Text('Payable to: XYZ School',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Bank Account: 123-456-789'),
                pw.Text('Branch: ABC Branch'),
                pw.SizedBox(height: 40),

                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text('Thank you!',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

Future<void> _savePdf(BuildContext context) async {
  try {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      final Uint8List pdfBytes = await _generatePdf();  // Ensure this is returning binary data

      // Get the Downloads directory (ensure it's accessible)
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${downloadsDirectory.path}/fee_voucher.pdf';
      final file = File(filePath);

      // Write the binary data as the PDF file
      await file.writeAsBytes(pdfBytes, flush: true);

      print('PDF saved at: $filePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at: $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save PDF: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Voucher PDF'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _savePdf(context),
          icon: Icon(Icons.download),
          label: Text('Download PDF'),
        ),
      ),
    );
  }
}
