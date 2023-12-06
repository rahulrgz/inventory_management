import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.any);
  return image;
}

Future<DateTime?> pickDateTo({required BuildContext context}) async {
  DateTime? date;
  await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now())
      .then((pickedDate) {
    if (pickedDate != null) {
      date = DateTime(
          pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
    }
  });
  return date;
}

Future<DateTime?> pickDateFrom({required BuildContext context}) async {
  DateTime? date;
  await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now())
      .then((pickedDate) {
    if (pickedDate != null) {
      date =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
    }
  });
  return date;
}

setSearchParam(String caseNumber) {
  List<String> caseSearchList = <String>[];
  String temp = "";

  List<String> nameSplits = caseNumber.split(" ");
  for (int i = 0; i < nameSplits.length; i++) {
    String name = "";

    for (int k = i; k < nameSplits.length; k++) {
      name = "$name${nameSplits[k]} ";
    }
    temp = "";

    for (int j = 0; j < name.length; j++) {
      temp = temp + name[j];
      caseSearchList.add(temp.toUpperCase());
    }
  }
  return caseSearchList;
}

showCommonAlertDialog(BuildContext context, String message, String message1,
    String message2, String message3) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Pallete.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // Set the background color to red
        title: Text(
          message,
          style: const TextStyle(
              color: Pallete.primaryColor), // Set text color to white
        ),
        content: Text(
          message1,
          style: const TextStyle(
              color: Pallete.primaryColor), // Set text color to white
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              message2,
              style: const TextStyle(
                  color: Pallete.primaryColor), // Set text color to white
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              message3,
              style: const TextStyle(
                  color: Pallete.primaryColor), // Set text color to white
            ),
          ),
        ],
      );
    },
  );
}
