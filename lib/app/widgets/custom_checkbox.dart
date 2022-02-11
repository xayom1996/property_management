import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';

class CustomCheckBox extends StatefulWidget {
  final List<String> choices;
  final String checkedColor;
  final Function(String) onChange;
  const CustomCheckBox({Key? key, required this.choices, required this.onChange, this.checkedColor = ''}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  String checkedColor = '';

  @override
  void initState() {
    checkedColor = widget.checkedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var color in widget.choices)
          GestureDetector(
            onTap: () {
              setState(() {
                if (checkedColor == color){
                  checkedColor = '';
                } else {
                  checkedColor = color;
                }
                widget.onChange(checkedColor);
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(30) //                 <--- border radius here
                ),
                border: color == checkedColor
                    ? Border.all(color: Color(int.parse(color)), width: 2)
                    : null,
                // color: color,
              ),
              child: Center(
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(22) //                 <--- border radius here
                    ),
                    color: Color(int.parse(color)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}