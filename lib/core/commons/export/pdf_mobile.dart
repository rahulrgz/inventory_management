// // import 'dart:io';
// // import 'dart:typed_data';
// //
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// //
// // import '../../../models/billitem_model.dart';
// // import '../../global_variables/global_variables.dart';
// //
// // class PdfMobile extends StatefulWidget {
// //   const PdfMobile({super.key});
// //
// //   @override
// //   State<PdfMobile> createState() => _PdfMobileState();
// // }
// //
// // class _PdfMobileState extends State<PdfMobile> {
// //   void previewPdf(List<BillItems> tableData) async {
// //     final pdf = pw.Document();
// //
// //     pdf.addPage(
// //       pw.MultiPage(
// //         build: (pw.Context context) => [
// //           pw.Header(
// //             level: 0,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.start,
// //               children: [
// //                 pw.Column(
// //                     mainAxisAlignment: pw.MainAxisAlignment.start,
// //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
// //                     children: [
// //                       pw.Text('Company: Nahla SuperMarket'),
// //                       pw.Text('Email: nahlasupermarket@gmail.com'),
// //                       pw.Text('Phone: +91 8848646656'),
// //                     ]),
// //                 pw.SizedBox(height: deviceHeight * 0.02),
// //                 pw.Row(
// //                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       pw.Text(
// //                         'Invoice Bill',
// //                         style: pw.TextStyle(fontSize: deviceHeight * 0.045),
// //                       ),
// //                       pw.Column(
// //                           crossAxisAlignment: pw.CrossAxisAlignment.end,
// //                           children: [
// //                             pw.Text(
// //                                 'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
// //                                 style: pw.TextStyle(
// //                                     fontSize: deviceHeight * 0.017)),
// //                             pw.Text(
// //                                 'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
// //                                 style: pw.TextStyle(
// //                                     fontSize: deviceHeight * 0.017)),
// //                           ])
// //                     ]),
// //               ],
// //             ),
// //           ),
// //           pw.Table.fromTextArray(
// //             context: context,
// //             headers: ['Item', 'Qty', 'Price', 'Total'],
// //             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
// //             cellAlignment: pw.Alignment.center,
// //             data: tableData
// //                 .map((item) => [
// //                       item.itemName,
// //                       item.quantity.toString(),
// //                       (item.price.toStringAsFixed(2)),
// //                       ((item.quantity * item.price).toStringAsFixed(2)),
// //                     ])
// //                 .toList(),
// //             border: pw.TableBorder.all(
// //               color: PdfColors.grey200,
// //               width: 0.005,
// //             ),
// //           ),
// //           pw.SizedBox(height: deviceHeight * 0.03),
// //           pw.Divider(color: PdfColors.grey300),
// //           pw.SizedBox(height: deviceHeight * 0.012),
// //           pw.Row(
// //             mainAxisAlignment: pw.MainAxisAlignment.end,
// //             children: [
// //               pw.Text('Grand Total: 200',
// //                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //
// //     final tempDir = await getTemporaryDirectory();
// //     final pdfFile = File('${tempDir.path}/invoice.pdf');
// //     await pdfFile.writeAsBytes(await pdf.save());
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         body: PdfPreview(
// //           onPrintError: (context, error) => Text('Sorry'),
// //           build: (PdfPageFormat format) => previewPdf(),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:inventory_management_shop/core/theme/pallete.dart';
// import 'package:inventory_management_shop/core/utils.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// import '../../../models/billitem_model.dart';
// import '../../global_variables/global_variables.dart';
//
// class PdfMobile extends StatefulWidget {
//   const PdfMobile({Key? key}) : super(key: key);
//
//   @override
//   State<PdfMobile> createState() => _PdfMobileState();
// }
//
// class _PdfMobileState extends State<PdfMobile> {
//   Future<Uint8List> previewPdf(List<BillItems> tableData) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.MultiPage(
//         build: (pw.Context context) => [
//           pw.Header(
//             level: 0,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Column(
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text('Company: Nahla SuperMarket'),
//                       pw.Text('Email: nahlasupermarket@gmail.com'),
//                       pw.Text('Phone: +91 8848646656'),
//                     ]),
//                 pw.SizedBox(height: deviceHeight * 0.02),
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text(
//                         'Invoice Bill',
//                         style: pw.TextStyle(fontSize: deviceHeight * 0.045),
//                       ),
//                       pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.end,
//                           children: [
//                             pw.Text(
//                                 'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
//                                 style: pw.TextStyle(
//                                     fontSize: deviceHeight * 0.017)),
//                             pw.Text(
//                                 'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
//                                 style: pw.TextStyle(
//                                     fontSize: deviceHeight * 0.017)),
//                           ])
//                     ]),
//               ],
//             ),
//           ),
//           pw.Table.fromTextArray(
//             context: context,
//             headers: ['Item', 'Qty', 'Price', 'Total'],
//             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             cellAlignment: pw.Alignment.center,
//             data: tableData.map((tableData) {
//               return [
//                 tableData.itemName,
//                 tableData.quantity.toString(),
//                 (tableData.price.toStringAsFixed(2)),
//                 ((tableData.quantity * tableData.price).toStringAsFixed(2)),
//               ];
//             }).toList(),
//             border: pw.TableBorder.all(
//               color: PdfColors.grey200,
//               width: 0.005,
//             ),
//           ),
//           pw.SizedBox(height: deviceHeight * 0.03),
//           pw.Divider(color: PdfColors.grey300),
//           pw.SizedBox(height: deviceHeight * 0.012),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.end,
//             children: [
//               pw.Text('Grand Total: 200',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             ],
//           ),
//         ],
//       ),
//     );
//
//     final tempDir = await getTemporaryDirectory();
//     final pdfFile = File('${tempDir.path}/invoice.pdf');
//     await pdfFile.writeAsBytes(await pdf.save());
//     return pdfFile.readAsBytesSync();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Pallete.containerColor,
//       appBar: AppBar(
//         backgroundColor: Pallete.secondaryColor,
//         elevation: 0,
//       ),
//       body: PdfPreview(
//         pdfFileName: "Invoice Bill",
//         canDebug: false,
//         dynamicLayout: false,
//         canChangeOrientation: true,
//         shouldRepaint: true,
//         onPrintError: (context, error) =>
//             showSnackBar(context, 'Error, Please try after some time!'),
//         build: (PdfPageFormat format) =>
//             previewPdf(), // Pass the list of BillItems here
//       ),
//     );
//   }
// }
