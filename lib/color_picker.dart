import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyColorPicker extends StatefulWidget {
  const MyColorPicker({
    Key? key,
    required this.title,
    required this.color,
    required this.onColorChanged,
  }) : super(key: key);

  final String title;
  final Color color;
  final Function(Color) onColorChanged;

  @override
  State<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  late Color selectedColor;
  @override
  void initState() {
    selectedColor = widget.color;
    super.initState();
  }

  void buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            setState(() => selectedColor = widget.color);
            return Future.value(true);
          },
          child: AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) => setState(() => selectedColor = color),
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  widget.onColorChanged(selectedColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: selectedColor,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => buildShowDialog(context),
                icon: Icon(
                  CupertinoIcons.pen,
                  color: HSLColor.fromColor(widget.color).lightness > 0.5 ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.title),
          ),
        ],
      ),
    );
  }
}
