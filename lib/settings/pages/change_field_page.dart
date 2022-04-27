import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/objects/pages/upload_document_page.dart';
import 'package:property_management/objects/widgets/action_bottom_sheet.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/input_field.dart';

class ChangeFieldPage extends StatefulWidget {
  final String title;
  final String? selectItem;
  final List? items;
  final Function? onSave;
  ChangeFieldPage({Key? key, required this.title, this.selectItem, this.items, this.onSave}) : super(key: key);

  @override
  State<ChangeFieldPage> createState() => _ChangeFieldPageState();
}

class _ChangeFieldPageState extends State<ChangeFieldPage> {
  String checkedItem = '';

  @override
  void initState() {
    checkedItem = widget.selectItem ?? '';
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: null,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoxIcon(
              iconPath: 'assets/icons/back.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: body,
                ),
              ),
            ),
            BoxIcon(
              iconPath: 'assets/icons/check.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                if (widget.onSave != null) {
                  widget.onSave!(checkedItem);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in widget.items!)
              ContainerForTransition(
                title: item,
                icon: item.contains(checkedItem) && isNotEmpty(checkedItem) ? Icons.check : null,
                onTap: () {
                  setState(() {
                    checkedItem = item;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}