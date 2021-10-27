import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:morph_kasten/data.dart';

Map<int, List<Color>> colors = {
  0: const [
    Color(0x66803F44),
    Color(0x80715A37),
    Color(0x4053803F),
  ],
  1: const [
    Color(0xffd56b79),
    Color(0xffcba960),
    Color(0xff7ace65),
  ]
};
double padding = 8.0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tfName = TextEditingController();
  TextEditingController tfNumber = TextEditingController();
  TextEditingController tfParent = TextEditingController();
  TextEditingController tfSubKey = TextEditingController();
  TextEditingController tfImage = TextEditingController();
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LogCSV().readFile(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Scaffold(
          body: StaggeredGridView.countBuilder(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data.isNotEmpty) {
                int groupColor = Random().nextInt(3);
                String parentKey = data.keys.toList()[index];
                Map<String, List<Entity>> subs = data[parentKey]!;
                List<Widget> parentGifts = [];
                for (String key in subs.keys) {
                  if (key != 'parent')
                    parentGifts.add(
                      buildSubGroup(
                        key,
                        List<Widget>.generate(
                          subs[key]!.length,
                          (g) => buildGift(
                            parentKey,
                            key,
                            subs[key]![g],
                            groupColor,
                          ),
                        ),
                        groupColor,
                      ),
                    );
                  else
                    for (Entity gift in subs[key]!)
                      parentGifts.add(
                        buildGift(
                          parentKey,
                          key,
                          gift,
                          groupColor,
                        ),
                      );
                }
                return buildGroup(
                  parentKey,
                  parentGifts,
                  groupColor,
                );
              } else {
                return Container();
              }
            },
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: const Icon(CupertinoIcons.square_arrow_down, color: Colors.white),
                label: "Load CSV file",
                onTap: () async {
                  await LogCSV().loadFile();
                  setState(() {});
                },
              ),
              SpeedDialChild(
                child: const Icon(CupertinoIcons.share_up, color: Colors.white),
                label: "Share CSV file",
                onTap: () => LogCSV().shareFile(context),
              ),
              SpeedDialChild(
                child: const Icon(CupertinoIcons.floppy_disk, color: Colors.white),
                label: "Save list",
                onTap: () => LogCSV().writeFile(),
              ),
              SpeedDialChild(
                child: const Icon(CupertinoIcons.delete, color: Colors.white),
                label: "Clear list",
                onTap: () async {
                  await LogCSV().deleteFile();
                  data.clear();
                  setState(() {});
                },
              ),
              SpeedDialChild(
                child: const Icon(CupertinoIcons.add, color: Colors.white),
                label: "Add gift",
                onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors[0]![Random().nextInt(3)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildDialogContent(Entity(name: "", image: "", number: 1, checked: false), "", ""),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      ),
                                      onPressed: () {
                                        String parent = tfParent.text;
                                        String subKey = tfSubKey.text;
                                        if (data[parent] == null) data[parent] = <String, List<Entity>>{};
                                        if (data[parent]![subKey] == null) data[parent]![subKey] = <Entity>[];
                                        data[parent]![subKey]!.add(Entity(name: tfName.text, image: tfImage.text, number: int.parse(tfNumber.text), checked: checked));
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      ),
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildGroup(String groupName, List<Widget> children, int color) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          color: colors[0]![color],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(groupName),
              Flexible(
                child: StaggeredGridView.countBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  itemCount: children.length,
                  itemBuilder: (context, index) => children[index],
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubGroup(String name, List<Widget> children, int color) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          color: colors[0]![color],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              Flexible(
                child: StaggeredGridView.countBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  itemCount: children.length,
                  itemBuilder: (context, index) => children[index],
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGift(String key, String subKey, Entity gift, int color) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: CupertinoContextMenu(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors[0]![color],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: padding),
                        child: RichText(
                          text: TextSpan(
                            text: gift.name + '  ',
                            children: <TextSpan>[
                              if (gift.number != 1) TextSpan(text: "x${gift.number}", style: TextStyle(color: colors[1]![color], fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (gift.image != "")
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: Image.network(
                            gift.image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: gift.checked
                  ? Stack(
                      children: [
                        const Icon(
                          CupertinoIcons.circle_fill,
                          color: Colors.white,
                        ),
                        Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: colors[1]![2],
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Icon(
                          CupertinoIcons.circle_fill,
                          color: colors[1]![0],
                        ),
                        const Icon(
                          CupertinoIcons.circle,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
          ],
        ),
        actions: <Widget>[
          CupertinoContextMenuAction(
            child: const Text('Save edit'),
            onPressed: () {
              // delete old version
              bool d = gift.checked;
              data[key]![subKey]!.remove(gift);
              if (data[key]![subKey]!.isEmpty) data[key]!.remove(subKey);
              if (data[key]!.isEmpty) data.remove(key);
              // create new version
              String parent = tfParent.text;
              String newSubKey = tfSubKey.text;
              if (data[parent] == null) data[parent] = <String, List<Entity>>{};
              if (data[parent]![newSubKey] == null) data[parent]![newSubKey] = <Entity>[];
              data[parent]![newSubKey]!.add(Entity(name: tfName.text, image: tfImage.text, number: int.parse(tfNumber.text), checked: d));
              setState(() {});
              Navigator.pop(context);
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoContextMenuAction(
            child: gift.checked ? const Text('Uncheck') : const Text('Check ready'),
            onPressed: () {
              setState(() => gift.checked = !gift.checked);
              Navigator.pop(context);
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Remove'),
            onPressed: () {
              data[key]![subKey]!.remove(gift);
              if (data[key]![subKey]!.isEmpty) data[key]!.remove(subKey);
              if (data[key]!.isEmpty) data.remove(key);
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
        previewBuilder: (BuildContext context, Animation<double> animation, Widget child) {
          return Container(
            decoration: BoxDecoration(
              color: colors[0]![color],
              borderRadius: BorderRadius.circular(20),
            ),
            child: buildDialogContent(gift, key, subKey),
          );
        },
      ),
    );
  }

  Widget buildDialogContent(Entity gift, String parentKey, String subKey) {
    tfName.text = gift.name;
    tfNumber.text = gift.number.toString();
    tfParent.text = parentKey;
    tfSubKey.text = subKey;
    tfImage.text = gift.image;
    checked = gift.checked;
    return Padding(
      padding: EdgeInsets.all(2 * padding),
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Gift name'),
                    SizedBox(width: padding),
                    buildTextField(tfName, 200),
                  ],
                ),
                SizedBox(height: padding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Number'),
                    SizedBox(width: padding),
                    buildTextField(tfNumber, 50),
                  ],
                ),
                SizedBox(height: padding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Key'),
                    SizedBox(width: padding),
                    buildTextField(tfParent, 200),
                  ],
                ),
                if (subKey != 'parent')
                  Column(
                    children: [
                      SizedBox(height: padding),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('SubKey'),
                          SizedBox(width: padding),
                          buildTextField(tfSubKey, 150),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: padding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Image'),
                    SizedBox(width: padding),
                    buildTextField(tfImage, 250),
                  ],
                ),
                SizedBox(height: padding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bought?'),
                    SizedBox(width: padding),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Checkbox(
                          value: checked,
                          onChanged: (changed) => setState(() => checked = changed ?? false),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (gift.image != "")
              Flexible(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      child: Image.network(
                        gift.image,
                        fit: BoxFit.fitWidth,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, double width) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        autofocus: false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //contentPadding: const EdgeInsets.only(left: 5.0, bottom: 5.0, top: 5.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
