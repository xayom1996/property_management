import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/input_field.dart';

class CustomTabView extends StatelessWidget {
  final List<Map> objectItems;
  final Widget? textButton;
  const CustomTabView({Key? key, required this.objectItems, this.textButton}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44), vertical: 16),
      child: textButton ?? SingleChildScrollView(
            child: Column(
              children: [
                for (var item in objectItems)
                  BoxInputField(
                      controller: TextEditingController(text: item['value']),
                      title: item['title'],
                      enabled: false,
                      backgroundColor: Color(0xffF5F5F5).withOpacity(0.6)
                  ),
              ],
            ),
          ),
    );
  }

}