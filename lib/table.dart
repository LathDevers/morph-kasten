import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morph_kasten/data.dart';
import 'package:morph_kasten/theme_provider.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({Key? key, required this.titleColor, required this.cellColor}) : super(key: key);

  final Color titleColor;
  final Color cellColor;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  int sRow = -1, sColumn = -1;
  int eRow = -1, eColumn = -1;
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<TableRow> table = buildTable();
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: table,
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

  Widget buildTitleCell(String text, int row, int column) => wrapper(
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: HSLColor.fromColor(widget.titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
        ),
        widget.titleColor,
      );

  Widget buildCell(String text, int row, int column) => wrapper(
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: HSLColor.fromColor(widget.cellColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
        ),
        widget.cellColor,
      );

  Widget buildPlaceHolder() => wrapper(
        Container(),
        Colors.transparent,
      );

  Widget wrapper(Widget child, Color color) => Padding(
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

class EditTableWidget extends StatefulWidget {
  const EditTableWidget({Key? key, required this.titleColor, required this.cellColor}) : super(key: key);

  final Color titleColor;
  final Color cellColor;

  @override
  State<EditTableWidget> createState() => _EditTableWidgetState();
}

class _EditTableWidgetState extends State<EditTableWidget> {
  int sRow = -1, sColumn = -1;
  int eRow = -1, eColumn = -1;
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<TableRow> table = buildTable();
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: table,
    );
  }

  List<TableRow> buildTable() {
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
        } else if (i == 0)
          newRow.add(buildTitleCell(data[r][i], r, i));
        else
          newRow.add(buildCell(data[r][i], r, i));
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

  Widget buildTitleCell(String text, int row, int column) => TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: mouseRegionWrapper(
          row,
          column,
          wrapper(
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: HSLColor.fromColor(widget.titleColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
            ),
            widget.titleColor,
          ),
        ),
      );

  Widget buildCell(String text, int row, int column) {
    myController.text = text;
    return eRow == row && eColumn == column
        ? editTextWidget(row, column)
        : TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: mouseRegionWrapper(
              row,
              column,
              wrapper(
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HSLColor.fromColor(widget.cellColor).lightness > 0.5 ? MyThemes.lightTheme.primaryColor : MyThemes.darkTheme.primaryColor),
                ),
                widget.cellColor,
              ),
            ),
          );
  }

  Widget buildAddCell(int row, int column) {
    myController.text = "";
    return GestureDetector(
      child: eRow == row && eColumn == column
          ? editTextWidget(row, column)
          : wrapper(
              const Icon(CupertinoIcons.add),
              Colors.grey,
            ),
      onTap: () => setState(() {
        eRow = row;
        eColumn = column;
      }),
    );
  }

  Widget buildPlaceHolder() => wrapper(
        Container(),
        Colors.transparent,
      );

  Widget wrapper(Widget child, Color color) => Padding(
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

  Widget mouseRegionWrapper(int row, int column, Widget child) => MouseRegion(
        child: row == sRow && column == sColumn
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  child,
                  IconButton(
                    onPressed: () => setState(() {
                      eRow = row;
                      eColumn = column;
                    }),
                    icon: const Icon(
                      CupertinoIcons.pencil_circle_fill,
                      color: Colors.white,
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

  Widget editTextWidget(int row, int column) => wrapper(
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
                onSubmitted: (_) => applyInput(row, column),
              ),
            ),
            IconButton(
              onPressed: () => applyInput(row, column),
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
      );

  void applyInput(int row, int column) {
    return setState(() {
      if (data.length < row + 1)
        data.add([myController.text]);
      else if (data[row].length < column + 1)
        data[row].add(myController.text);
      else if (data[row][column].isNotEmpty) data[row][column] = myController.text;
      myController.clear();
      eRow = -1;
      eColumn = -1;
    });
  }
}
