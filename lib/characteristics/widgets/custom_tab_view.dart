import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/characteristics/widgets/document_page.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/custom_checkbox.dart';
import 'package:property_management/widgets/input_field.dart';

class CustomTabView extends StatelessWidget {
  final List<Map> objectItems;
  final Widget? textButton;
  final Widget? child;
  final bool? checkbox;
  const CustomTabView({Key? key, required this.objectItems, this.textButton, this.child, this.checkbox = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child == null
        ? Container(
            padding: EdgeInsets.only(left: horizontalPadding(context, 44), right:horizontalPadding(context, 44), top: 16),
            child: textButton ?? SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item in objectItems)
                        BoxInputField(
                          controller: TextEditingController(text: item['value']),
                          title: item['title'],
                          placeholder: 'Данные не заполнены',
                          enabled: false,
                          backgroundColor: Color(0xffF5F5F5).withOpacity(0.6),
                          trailing: item['title'] == 'Договор водоснабжения'
                              ? BoxIcon(
                                  iconPath: 'assets/icons/document.svg',
                                  iconColor: Color(0xff5589F1),
                                  backgroundColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DocumentPage()),
                                    );
                                  },
                                )
                              : item['value'] == ''
                                ? Tooltip(
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding(context, 60, portraitPadding: 40)
                                    ),
                                    textStyle: body.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                    ),
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: false,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 20,
                                          offset: Offset(0, 8), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    message: 'Данные не заполнены, обратитесь к вашему менеджеру',
                                    child: BoxIcon(
                                      iconPath: 'assets/icons/question.svg',
                                      iconColor: Color(0xff5589F1),
                                      backgroundColor: Colors.white,
                                    )
                                  )
                                : null,
                        ),
                      if (checkbox != false)
                        CustomCheckBox(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
          )
        : child!;
  }

}