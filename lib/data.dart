import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Map<String, Map<String, List<Entity>>> data = <String, Map<String, List<Entity>>>{};

class Entity {
  String name;
  String image;
  int number;
  bool checked;

  Entity({
    required this.name,
    required this.image,
    required this.number,
    required this.checked,
  });
}

class LogCSV {
  String csvData = '';

  Future<void> writeFile() async {
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    File file = File("$dirPath/mydata.csv");
    await deleteFile();
    csvData = '';
    for (String key in data.keys)
      for (String subKey in data[key]!.keys)
        for (Entity gift in data[key]![subKey]!)
          csvData += const ListToCsvConverter().convert([
                [key, subKey, gift.name, gift.image, gift.number.toString(), gift.checked ? 't' : 'f']
              ]) +
              '\r\n';
    await file.writeAsString(csvData, mode: FileMode.writeOnly);
  }

  Future<void> readFile() async {
    String dirPath = await getApplicationDocumentsDirectory().then((value) => value.path);
    File file = File("$dirPath/mydata.csv");
    final Stream<List<int>> input = file.openRead();
    final List<dynamic> fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
    for (List<dynamic> row in fields) {
      if (data[row[0]] == null) data[row[0]] = <String, List<Entity>>{};
      if (data[row[0]]![row[1]] == null) data[row[0]]![row[1]] = <Entity>[];
      bool contains = false;
      for (Entity entity in data[row[0]]![row[1]]!) {
        contains = entity.name == row[2] && entity.image == row[3] && entity.number == int.parse(row[4]);
        if (contains) break;
      }
      if (!contains) data[row[0]]![row[1]]!.add(Entity(name: row[2], image: row[3], number: row[4], checked: row[5] == 't' ? true : false));
    }
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
