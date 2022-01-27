import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;
  Color checkedColor = markedColors[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  checkColor: Colors.white,
                  splashRadius: 3,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
            ),
            SizedBox(width: 14,),
            Text(
              'Отмеченный клиент',
              style: body,
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        if (isChecked)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var color in markedColors)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      checkedColor = color;
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
                          ? Border.all(color: color, width: 2)
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
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
      ],
    );
  }
}