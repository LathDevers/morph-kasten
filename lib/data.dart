// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

List<List<String>> data = [];

class LogCSV {
  void exportCSV() {
    html.AnchorElement(href: "data:text/plain;charset=utf-8,${const ListToCsvConverter().convert(data)}")
      ..setAttribute("download", "data.csv")
      ..click();
  }

  Future<bool> importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      );
      if (result != null) {
        test(result);
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

  void clearData() => data = [];

  void test(FilePickerResult? result) {
    String s = String.fromCharCodes(result!.files.first.bytes!);
    data = const CsvToListConverter().convert(s).map((row) => row.map((e) => e.toString()).toList()).toList();
  }
}
