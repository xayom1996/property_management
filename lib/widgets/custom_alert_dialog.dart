import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/styles.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Вы действительно хотите удалить карточку объекта?",
        style: caption1.copyWith(
          color: Color(0xff151515)
        ),
      ),
      // content: new Text("This is my content"),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Удалить",
            style: body,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Отмена",
            style: body.copyWith(
              color: Color(0xff5589F1),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }

}