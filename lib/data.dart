import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

List<List<String>> data = [];

class LogCSV {
  List<String> newRow = [];

  Future<void> writeFile() async {
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    File file = File("$dirPath/mydata.csv");
    await deleteFile();
    await file.writeAsString(const ListToCsvConverter().convert(data), mode: FileMode.writeOnly);
  }

  Future<void> readFile() async {
    data = [];
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    List<List<dynamic>> readData = const CsvToListConverter().convert(await rootBundle.loadString("$dirPath/mydata.csv"));
    for (List<dynamic> row in readData) {
      newRow = [];
      for (dynamic cell in row) newRow.add(cell.toString());
      data.add(newRow);
    }
  }

  void clearData() {
    data = [];
  }

  Future<void> shareFile(BuildContext context) async {
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.shareFiles(["$dirPath/mydata.csv"], sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<bool> loadFile() async {
    try {
      String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      );
      if (result != null) {
        await deleteFile();
        await File(result.files.first.path!).copy("$dirPath/mydata.csv");
        return true;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation " + e.toString());
      return false;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<void> deleteFile() async {
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    if (await File("$dirPath/mydata.csv").exists()) await File("$dirPath/mydata.csv").delete();
  }
}
