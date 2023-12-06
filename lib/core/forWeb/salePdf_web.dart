import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html';
import '../../models/billitem_model.dart';


void exportToPDF(List<BillItems> tableData,sale,ref,shop) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${shop}', style: pw.TextStyle(fontSize: deviceWidth * 0.01, fontWeight: pw.FontWeight.bold)),
                    pw.Text(' +1234567890', style: pw.TextStyle(fontSize: deviceWidth * 0.01)),
                    pw.Text(' London,679820', style: pw.TextStyle(fontSize: deviceWidth * 0.01)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Invoice:${sale.id}', style: pw.TextStyle(fontSize: deviceWidth * 0.01, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Customer:${sale.name}', style: pw.TextStyle(fontSize: deviceWidth * 0.01)),
                    pw.Text('Date: ${DateFormat('dd-MM-yyy').format(sale.saleDate)}', style: pw.TextStyle(fontSize: deviceWidth * 0.01)),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            pw.Text('Invoice Details', style: pw.TextStyle(fontSize: deviceWidth * 0.02, fontWeight: pw.FontWeight.bold)),
            pw.Table.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: pw.TextStyle(fontSize: 12),
              data: [
                ['Item', 'Qty', 'Price', 'Total'], // Custom header row
                ...tableData.map((item) => [
                  item.itemName,
                  item.itemQuantity.toString(),
                  item.salePrice.toStringAsFixed(2),
                  (item.itemQuantity * item.salePrice).toStringAsFixed(2),
                ]),
                ['Grand Total', '', '', '${sale.totalPrice}.00/-'],
              ],
            ),
          ],
        );
      },
    ),
  );

  final Uint8List pdfData = await pdf.save();
  final blob = Blob([Uint8List.fromList(pdfData)]);
  final url = Url.createObjectUrlFromBlob(blob);

  final anchor = AnchorElement(href: url)
    ..setAttribute("download", "salesInvoice-${sale.name}.pdf")
    ..text = "Download PDF";

  // Append the download link to the DOM
  anchor.click();

  // Revoke the URL to free up resources
  Url.revokeObjectUrl(url);
}
