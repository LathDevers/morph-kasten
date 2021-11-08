import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:morph_kasten/color_picker.dart';
import 'package:morph_kasten/data.dart';
import 'package:morph_kasten/theme_provider.dart';

Color backgroundColor = const Color(0xff2f3437);
Color titleColor = Colors.red;
Color cellColor = Colors.black;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sRow = -1, sColumn = -1;
  int eRow = -1, eColumn = -1;
  TextEditingController myController = TextEditingController();
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    List<TableRow> table = edit ? buildTableEdit() : buildTable();
    return Scaffold(
      backgroundColor: backgroundColor,
      body: edit
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTableWidget(table),
                colorPickers(),
              ],
            )
          : buildTableWidget(table),
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

  Widget buildTableWidget(List<TableRow> table) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: table,
    );
  }

  SpeedDialChild buildDeleteButton() {
    return SpeedDialChild(
      child: const Icon(CupertinoIcons.delete, color: Colors.white),
      label: "Delete",
      onTap: () {
        LogCSV().clearData();
        setState(() {});
      },
    );
  }

  SpeedDialChild buildLoadButton() {
    return SpeedDialChild(
      child: const Icon(CupertinoIcons.square_arrow_up, color: Colors.white),
      label: "Import",
      onTap: () async {
        await LogCSV().importCSV();
        setState(() {});
      },
    );
  }

  SpeedDialChild buildSaveButton() {
    return SpeedDialChild(
      child: const Icon(CupertinoIcons.cloud_download, color: Colors.white),
      label: "Download",
      onTap: () => LogCSV().exportCSV(),
    );
  }

  SpeedDialChild buildEditButton() {
    return SpeedDialChild(
      child: edit ? const Icon(CupertinoIcons.pencil_slash, color: Colors.white) : const Icon(CupertinoIcons.pen, color: Colors.white),
      label: edit ? "End editing" : "Edit",
      onTap: () {
        setState(() => edit = !edit);
      },
    );
  }

  List<TableRow> buildTable() {
    int maxCellInRow = 0;
    for (List<String> row in data) maxCellInRow = row.length > maxCellInRow ? row.length : maxCellInRow;
    List<TableRow> table = <TableRow>[];
    int i = 0;
    for (int r = 0; r < data.length; r++) {
      List<Widget> newRow = <Widget>[];
      for (i = 0; i < data[r].length; i++) {
        if (i == data[r].length - 1) {
          if (i == 0)
            newRow.add(buildTitleCell(data[r][i], r, i));
          else
            newRow.add(buildCell(data[r][i], r, i));
          for (int j = 0; j < maxCellInRow - i - 1; j++) newRow.add(buildPlaceHolder());
        } else if (i == 0) {
          newRow.add(buildTitleCell(data[r][i], r, i));
        } else {
          newRow.add(buildCell(data[r][i], r, i));
        }
      }
      table.add(TableRow(children: newRow));
    }
    return table;
  }

  List<TableRow> buildTableEdit() {
    int maxCellInRow = 0;
    for (List<String> row in data) maxCellInRow = row.length > maxCellInRow ? row.length : maxCellInRow;
    maxCellInRow += 1;
    List<TableRow> table = <TableRow>[];
    for (int r = 0; r < data.length; r++) {
      List<Widget> newRow = <Widget>[];
      for (int i = 0; i < data[r].length; i++) {
        if (i == data[r].length - 1) {
          if (i == 0)
            newRow.add(buildTitleCell(data[r][i], r, i));
          else
            newRow.add(buildCell(data[r][i], r, i));
          newRow.add(buildAddCell(r, i + 1));
          for (int j = 0; j < maxCellInRow - i - 2; j++) newRow.add(buildPlaceHolder());
        } else if (i == 0) {
          newRow.add(buildTitleCell(data[r][i], r, i));
        } else {
          newRow.add(buildCell(data[r][i], r, i));
        }
      }
      table.add(TableRow(children: newRow));
    }
    if (data.isEmpty)
      table.add(TableRow(children: [buildAddCell(0, 0)]));
    else
      table.add(
        TableRow(
          children: [
            buildAddCell(data.length, 0),
            ...List.generate(
              maxCellInRow - 1,
              (index) => buildPlaceHolder(),
            ),
          ],
        ),
      );
    return table;
  }

  Widget buildTitleCell(String text, int row, int column) {
    if (edit)
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: mouseRegionWrapper(
          row,
          column,
          wrapper(
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: HSLColor.fromColor(titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
            ),
            titleColor,
          ),
        ),
      );
    else
      return wrapper(
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: HSLColor.fromColor(titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
        ),
        titleColor,
      );
  }

  Widget buildCell(String text, int row, int column) {
    if (edit)
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: mouseRegionWrapper(
          row,
          column,
          wrapper(
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: HSLColor.fromColor(titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
            ),
            cellColor,
          ),
        ),
      );
    else
      return wrapper(
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: HSLColor.fromColor(titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
        ),
        cellColor,
      );
  }

  Widget buildAddCell(int row, int column) => GestureDetector(
        child: eRow == row && eColumn == column
            ? wrapper(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: CupertinoTextField(
                        controller: myController,
                        maxLines: 1,
                        clearButtonMode: OverlayVisibilityMode.always,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        if (data.length < row + 1)
                          data.add([myController.text]);
                        else
                          data[row].add(myController.text);
                        myController.clear();
                      }),
                      icon: const Icon(CupertinoIcons.check_mark_circled),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        eRow = -1;
                        eColumn = -1;
                      }),
                      icon: const Icon(CupertinoIcons.clear_circled),
                    ),
                  ],
                ),
                Colors.grey,
              )
            : wrapper(
                const Icon(CupertinoIcons.add),
                Colors.grey,
              ),
        onTap: () => setState(() {
          eRow = row;
          eColumn = column;
        }),
      );

  Widget buildPlaceHolder() => wrapper(
        Container(),
        Colors.transparent,
      );

  Widget wrapper(Widget child, Color color) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget mouseRegionWrapper(int row, int column, Widget child) {
    return MouseRegion(
      child: row == sRow && column == sColumn
          ? Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                child,
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.pencil_circle_fill,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          : child,
      onEnter: (p) => setState(() {
        sRow = row;
        sColumn = column;
      }),
      onExit: (p) => setState(() {
        sRow = -1;
        sColumn = -1;
      }),
    );
  }

  Widget colorPickers() {
    return Column(
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
}
