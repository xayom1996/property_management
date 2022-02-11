import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/objects/pages/upload_document_page.dart';
import 'package:property_management/objects/widgets/action_bottom_sheet.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/input_field.dart';

class DetailsTenant extends StatelessWidget {
  const DetailsTenant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxInputField(
          controller: TextEditingController(),
          placeholder: 'Введите получателя',
          title: 'Получатель',
          // isError: isError,
        ),
        BoxInputField(
          controller: TextEditingController(),
          placeholder: 'Введите счет получателя',
          title: 'Счет получателя',
          // isError: isError,
        ),
        BoxInputField(
          controller: TextEditingController(),
          placeholder: 'Введите БИК банка получателя',
          title: 'БИК банка получателя',
          // isError: isError,
        ),
        BoxInputField(
          controller: TextEditingController(),
          placeholder: '92323223',
          title: 'ИНН получателя',
          // isError: isError,
        ),
      ],
    );
  }
}