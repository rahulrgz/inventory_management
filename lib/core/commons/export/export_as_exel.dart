import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../../models/billitem_model.dart';

void exportToExcel(List<BillItems> tableData) async {
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
  if (bytes != null) {
    var directory = await getExternalStorageDirectory();
    var excelFile = File('${directory!.path}/excel_file.xlsx');
    await excelFile.writeAsBytes(bytes);

    await OpenFile.open(excelFile.path);
  }
}
