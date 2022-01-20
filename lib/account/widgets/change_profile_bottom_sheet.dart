import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';

class ChangeProfileBottomSheet extends StatefulWidget {
  const ChangeProfileBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChangeProfileBottomSheet> createState() => _ChangeProfileBottomSheetState();
}

class _ChangeProfileBottomSheetState extends State<ChangeProfileBottomSheet> {
  String currentProfile = 'Квытько Елена Владимировна';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44, portraitPadding: 0)),
      child: Container(
        height: 335,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Container(
                  height: 6,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Color(0xffE9ECEE),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Сменить аккаунт',
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentProfile = 'Пошукай Михайл Иванович';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Пошукай Михайл Иванович',
                            style: body,
                          ),
                          if (currentProfile == 'Пошукай Михайл Иванович')
                            Icon(
                              Icons.check,
                              size: 22,
                              color: Color(0xff5589F1),
                            )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentProfile = 'Квытько Елена Владимировна';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Квытько Елена Владимировна',
                            style: body,
                          ),
                          if (currentProfile == 'Квытько Елена Владимировна')
                            Icon(
                              Icons.check,
                              size: 22,
                              color: Color(0xff5589F1),
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw)),
              child: SizedBox(
                width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                child: BoxButton(
                  title: 'Добавить новый аккаунт',
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}