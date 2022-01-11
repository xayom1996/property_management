import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 335,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сортировка',
            style: body.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'По адресу',
                  style: body,
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'По названию',
                  style: body,
                ),
                Icon(
                  Icons.check,
                  size: 22,
                  color: Color(0xff5589F1),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          BoxButton(
            title: 'Применить',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    );
  }

}