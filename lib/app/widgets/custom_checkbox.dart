import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:provider/src/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final List<String> choices;
  final String checkedColor;
  final Function(String) onChange;
  final bool isChecked;
  const CustomCheckBox({Key? key, required this.choices, required this.onChange, this.checkedColor = '', required this.isChecked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.read<AppBloc>().state.user.isAdminOrManager()
      ? Column(
        children: [
          GestureDetector(
            onTap: () {
              if (isChecked) {
                onChange('');
              } else {
                onChange(choices.first);
              }
            },
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    checkColor: Colors.white,
                    splashRadius: 3,
                    value: isChecked,
                    onChanged: (bool? value) {
                      if (isChecked) {
                        onChange('');
                      } else {
                        onChange(choices.first);
                      }
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
          ),
          SizedBox(
            height: 24,
          ),
          isChecked
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var color in choices)
                  GestureDetector(
                    onTap: () {
                      onChange(color);
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
            )
          : Container(height: 30,),
        ],
      )
      : Container();
  }
}