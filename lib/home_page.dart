import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:morph_kasten/color_picker.dart';
import 'package:morph_kasten/data.dart';
import 'package:morph_kasten/table.dart';

Color backgroundColor = const Color(0xff2f3437);
Color titleColor = Colors.red;
Color cellColor = Colors.black;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: edit
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditTableWidget(titleColor: titleColor, cellColor: cellColor),
                colorPickers(),
              ],
            )
          : TableWidget(titleColor: titleColor, cellColor: cellColor),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          buildDeleteButton(),
          buildLoadButton(),
          buildSaveButton(),
          buildEditButton(),
        ],
      ),
    );
  }

  SpeedDialChild buildDeleteButton() => SpeedDialChild(
        child: const Icon(CupertinoIcons.delete, color: Colors.white),
        label: "Delete",
        onTap: () {
          LogCSV().clearData();
          setState(() {});
        },
      );

  SpeedDialChild buildLoadButton() => SpeedDialChild(
        child: const Icon(CupertinoIcons.square_arrow_up, color: Colors.white),
        label: "Import",
        onTap: () async {
          await LogCSV().importCSV();
          setState(() {});
        },
      );

  SpeedDialChild buildSaveButton() => SpeedDialChild(
        child: const Icon(CupertinoIcons.cloud_download, color: Colors.white),
        label: "Download",
        onTap: () => LogCSV().exportCSV(),
      );

  SpeedDialChild buildEditButton() => SpeedDialChild(
        child: edit ? const Icon(CupertinoIcons.pencil_slash, color: Colors.white) : const Icon(CupertinoIcons.pen, color: Colors.white),
        label: edit ? "End editing" : "Edit",
        onTap: () {
          setState(() => edit = !edit);
        },
      );

  Widget colorPickers() => Column(
        children: [
          MyColorPicker(
            title: "Background color",
            color: backgroundColor,
            onColorChanged: (color) => setState(() => backgroundColor = color),
          ),
          MyColorPicker(
            title: "Title color",
            color: titleColor,
            onColorChanged: (color) => setState(() => titleColor = color),
          ),
          MyColorPicker(
            title: "Cell color",
            color: cellColor,
            onColorChanged: (color) => setState(() => cellColor = color),
          ),
        ],
      );
}
