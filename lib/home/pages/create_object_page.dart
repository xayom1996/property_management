import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';

class CreateObjectPage extends StatelessWidget {
  CreateObjectPage({Key? key}) : super(key: key);

  List<Map> objectItems = [
    {'title': 'Название объекта', 'placeholder': 'Введите название объекта'},
    {'title': 'Адрес объекта', 'placeholder': 'Введите адрес объекта'},
    {'title': 'Площадь объекта', 'placeholder': 'Введите площадь объекта'},
    {'title': 'Собственник', 'placeholder': 'Введите собственника'},
    {'title': 'Выделенная мощность (электричество)', 'placeholder': 'Введите выделенную мощность'},
    {'title': 'Выделенная мощность (тепло) ', 'placeholder': 'Введите выделенную мощность'},
    {'title': 'Начальная стоимость', 'placeholder': 'Введите начальную стоимость'},
    {'title': 'Дата приобретения', 'placeholder': 'Введите дату приоюритения'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title: Row(
          children: [
            Spacer(),
            Text(
              'Новый объект',
              style: body,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BoxIcon(
                iconPath: 'assets/icons/clear.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in objectItems)
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: item['placeholder'],
                      title: item['title'],
                      enabled: false,
                      trailing: GestureDetector(
                        onTap: () {
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff5589F1),
                        ),
                      ),
                      // isError: isError,
                    ),
                  SizedBox(
                    height: 48.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24.h,
            // left: 100,
            // child: Container(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
              child: SizedBox(
                width: 0.9.sw,
                child: BoxButton(
                  title: 'Создать',
                  // disabled: isDisabledButton() ? false : true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}