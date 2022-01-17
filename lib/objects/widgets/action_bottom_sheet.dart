import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';

class ActionBottomSheet extends StatelessWidget {
  final Function() onFunc;

  const ActionBottomSheet({Key? key, required this.onFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: Text(
            'Загрузить с устройства',
          ),
          onPressed: onFunc,
        ),
        CupertinoActionSheetAction(
          child: const Text('Загрузить по ссылке'),
          onPressed: onFunc,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Отмена'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}