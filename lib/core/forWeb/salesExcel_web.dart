import 'dart:html';
import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../../models/billitem_model.dart';

void exportToExcelWeb(List<BillItems> tableData) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  sheetObject.insertRowIterables(['Item', 'Qty', 'Price', 'Total'], 0);

  for (var i = 0; i < tableData.length; i++) {
    sheetObject.insertRowIterables([
      tableData[i].itemName,
      tableData[i].itemQuantity.toString(),
      tableData[i].salePrice.toStringAsFixed(2),
      (tableData[i].itemQuantity * tableData[i].salePrice).toStringAsFixed(2),
    ], i + 1);
  }

  var bytes = excel.encode();

  final blob = Blob([Uint8List.fromList(bytes!)]);
  final url = Url.createObjectUrlFromBlob(blob);

  final anchor = AnchorElement(href: url)
    ..setAttribute("download", "salesExcel_file.xlsx")
    ..text = "Download Excel File";

  // Append the download link to the DOM
  anchor.click();

  // Revoke the URL to free up resources
  Url.revokeObjectUrl(url);
}
