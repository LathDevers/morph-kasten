import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:morph_kasten/data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sRow = -1, sColumn = -1;
  int eRow = -1, eColumn = -1;
  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    data = [
      ["111\na", "22211111", "333"],
      ["444", "555"],
      ["666"]
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return FutureBuilder(
    //future: LogCSV().readFile(),
    //builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
      table.add(TableRow(
        children: newRow,
      ));
    }
    return Scaffold(
      body: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: table,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(CupertinoIcons.floppy_disk, color: Colors.white),
            label: "Save",
            onTap: () async {
              await LogCSV().writeFile();
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: const Icon(CupertinoIcons.square_arrow_down, color: Colors.white),
            label: "Load",
            onTap: () async {
              await LogCSV().readFile();
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: const Icon(CupertinoIcons.delete, color: Colors.white),
            label: "Delete",
            onTap: () {
              LogCSV().clearData();
              setState(() {});
            },
          ),
        ],
      ),
    );
    //},
    //);
  }

  Widget buildTitleCell(String text, int row, int column) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: MouseRegion(
        child: row == sRow && column == sColumn
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  wrapper(
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    Colors.red,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.pencil_circle_fill,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : wrapper(
                Text(
                  text,
                  textAlign: TextAlign.center,
                ),
                Colors.red,
              ),
        onEnter: (p) => setState(() {
          sRow = row;
          sColumn = column;
        }),
        onExit: (p) => setState(() {
          sRow = -1;
          sColumn = -1;
        }),
      ),
    );
  }

  Widget buildCell(String text, int row, int column) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: MouseRegion(
        child: row == sRow && column == sColumn
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  wrapper(
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    Colors.black,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.pencil_circle_fill,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : wrapper(
                Text(
                  text,
                  textAlign: TextAlign.center,
                ),
                Colors.black,
              ),
        onEnter: (p) => setState(() {
          sRow = row;
          sColumn = column;
        }),
        onExit: (p) => setState(() {
          sRow = -1;
          sColumn = -1;
        }),
      ),
    );
  }

  Widget buildAddCell(int row, int column) {
    return GestureDetector(
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      data[row].add(myController.text);
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
  }

  Widget buildPlaceHolder() {
    return wrapper(
      Container(),
      Colors.transparent,
    );
  }

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
}
