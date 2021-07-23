import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


typedef void fuChangeColor(Color color);//!CHC

//#region [St]
class FColorPicker extends StatefulWidget {
      FColorPicker({required this.changeColor, required this.prevcolor});//!CHC

  final fuChangeColor changeColor;//!CHC
  Color prevcolor;

  @override
  State<StatefulWidget> createState() => _FColorPickerState();
}
//#endregion

class _FColorPickerState extends State<FColorPicker> {
 
  Color currentColor = Colors.redAccent;
  
  //void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return 
       ElevatedButton(
         onPressed: () {
           showDialog(
             context: context,
             builder: (BuildContext context) {
               return AlertDialog(
                 titlePadding: const EdgeInsets.all(0.0),
                 contentPadding: const EdgeInsets.all(0.0),
                 content: SingleChildScrollView(
                   child: ColorPicker(
                     pickerColor: widget.prevcolor,//currentColor,//!PRV
                     onColorChanged: widget.changeColor,//!CHC
                     colorPickerWidth: 300.0,
                     pickerAreaHeightPercent: 0.7,
                     enableAlpha: true,
                     displayThumbColor: true,
                     showLabel: true,
                     paletteType: PaletteType.hsv,
                     pickerAreaBorderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(2.0),
                       topRight: Radius.circular(2.0),
                     ),
                   ),
                 ),
                 actions: [
                   //TextButton(onPressed: widget.select, child: Text('Select')),
                 ],
               );
             },
           );
         },
         child: const Text('Change me'),
       );           
  }
}

