import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/styles.dart';

class LogoutAlertDialog extends StatelessWidget {
  const LogoutAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Вы действительно хотите выйти?",
        style: caption1.copyWith(
          color: Color(0xff151515)
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Отмена",
            style: body,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Выйти",
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