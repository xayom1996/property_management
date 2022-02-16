import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';

class ActionBottomSheet extends StatelessWidget {
  final Function() onUploadFromDevice;
  final Function() onUploadFromUrl;

  const ActionBottomSheet({Key? key, required this.onUploadFromDevice,
    required this.onUploadFromUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: Text(
            'Загрузить с устройства',
          ),
          onPressed: onUploadFromDevice,
        ),
        CupertinoActionSheetAction(
          child: const Text('Загрузить по ссылке'),
          onPressed: onUploadFromUrl,
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