import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/styles.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  const CustomAlertDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none, alignment: Alignment.center,
        children: [
          Container(
            // height: 270,
            width: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: Color(0xffFCFCFC),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  child: Text(
                    title,
                    // 'Вы действительно хотите удалить карточку объекта?',
                    textAlign: TextAlign.center,
                    style: caption1.copyWith(
                        color: Color(0xff151515)
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width:0.5, color: Color(0xffE9ECEE)),
                              right: BorderSide(width:0.5, color: Color(0xffE9ECEE)),
                              // bottom: BorderSide(color: Color(0xffE9ECEE)),
                            ),
                          ),
                          child: Text(
                            "Удалить",
                            textAlign: TextAlign.center,
                            style: body,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width:0.5, color: Color(0xffE9ECEE)),
                              left: BorderSide(width:0.5, color: Color(0xffE9ECEE)),
                            ),
                          ),
                          child: Text(
                            "Отмена",
                            textAlign: TextAlign.center,
                            style: body.copyWith(
                              color: Color(0xff5589F1),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
    return CupertinoAlertDialog(
      title: Text(
        "Вы действительно хотите удалить карточку объекта?",
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