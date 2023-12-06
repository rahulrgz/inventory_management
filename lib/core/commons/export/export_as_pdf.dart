import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/billitem_model.dart';
import '../../global_variables/global_variables.dart';

Future<Uint8List> previewPdfPurchase(List<BillItems> tableData) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Company: Company Name'),
                    pw.Text('Email: example@gmail.com'),
                    pw.Text('Phone: +91 1234567890'),
                  ]),
              pw.SizedBox(height: deviceHeight * 0.02),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Invoice Bill',
                      style: pw.TextStyle(fontSize: deviceHeight * 0.045),
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                              style:
                                  pw.TextStyle(fontSize: deviceHeight * 0.017)),
                          pw.Text(
                              'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
                              style:
                                  pw.TextStyle(fontSize: deviceHeight * 0.017)),
                        ])
                  ]),
            ],
          ),
        ),
        pw.Table.fromTextArray(
          context: context,
          headers: ['Item', 'Qty', 'Price', 'Total'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.center,
          data: tableData.map((tableData) {
            return [
              tableData.itemName,
              tableData.itemQuantity.toString(),
              (tableData.purchasePrice.toStringAsFixed(2)),
              ((tableData.itemQuantity * tableData.purchasePrice)
                  .toStringAsFixed(2)),
            ];
          }).toList(),
          border: pw.TableBorder.all(
            color: PdfColors.grey200,
            width: 0.005,
          ),
        ),
        pw.SizedBox(height: deviceHeight * 0.03),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: deviceHeight * 0.012),
        // pw.Row(
        //   mainAxisAlignment: pw.MainAxisAlignment.end,
        //   children: [
        //     pw.Text('Grand Total: ${calculateTotal().toStringAsFixed(2)}',
        //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        //   ],
        // ),
      ],
    ),
  );

  final tempDir = await getTemporaryDirectory();
  final pdfFile = File('${tempDir.path}/invoice.pdf');
  await pdfFile.writeAsBytes(await pdf.save());

  try {
    final fileBytes = await pdfFile.readAsBytes();
    OpenFile.open(pdfFile.path);
    return fileBytes;
  } catch (e) {
    print('Error occurred while generating or opening the PDF: $e');
    return Uint8List(0);
  }
}

Future<Uint8List> previewPdfSales(List<BillItems> tableData) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Company: Company Name'),
                    pw.Text('Email: example@gmail.com'),
                    pw.Text('Phone: +91 1234567890'),
                  ]),
              pw.SizedBox(height: deviceHeight * 0.02),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Invoice Bill',
                      style: pw.TextStyle(fontSize: deviceHeight * 0.045),
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                              style:
                                  pw.TextStyle(fontSize: deviceHeight * 0.017)),
                          pw.Text(
                              'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
                              style:
                                  pw.TextStyle(fontSize: deviceHeight * 0.017)),
                        ])
                  ]),
            ],
          ),
        ),
        pw.Table.fromTextArray(
          context: context,
          headers: ['Item', 'Qty', 'Price', 'Total'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.center,
          data: tableData.map((tableData) {
            return [
              tableData.itemName,
              tableData.itemQuantity.toString(),
              (tableData.salePrice.toStringAsFixed(2)),
              ((tableData.itemQuantity * tableData.salePrice)
                  .toStringAsFixed(2)),
            ];
          }).toList(),
          border: pw.TableBorder.all(
            color: PdfColors.grey200,
            width: 0.005,
          ),
        ),
        pw.SizedBox(height: deviceHeight * 0.03),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: deviceHeight * 0.012),
        // pw.Row(
        //   mainAxisAlignment: pw.MainAxisAlignment.end,
        //   children: [
        //     pw.Text('Grand Total: ${calculateTotal().toStringAsFixed(2)}',
        //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        //   ],
        // ),
      ],
    ),
  );

  final tempDir = await getTemporaryDirectory();
  final pdfFile = File('${tempDir.path}/invoice.pdf');
  await pdfFile.writeAsBytes(await pdf.save());

  try {
    final fileBytes = await pdfFile.readAsBytes();
    OpenFile.open(pdfFile.path);
    return fileBytes;
  } catch (e) {
    print('Error occurred while generating or opening the PDF: $e');
    return Uint8List(0);
  }
}

Future<void> generateAndSavePdf(List<BillItems> tableData) async {
  final pdfBytes = await previewPdfSales(tableData);
  final tempDir = await getTemporaryDirectory();
  final pdfFile = File('${tempDir.path}/invoice.pdf');
  await pdfFile.writeAsBytes(pdfBytes);
  OpenFile.open(pdfFile.path);
}
