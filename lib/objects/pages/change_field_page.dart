import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/input_field.dart';

class ChangeFieldPage extends StatefulWidget {
  final String title;
  final Map item;
  ChangeFieldPage({Key? key, required this.title, required this.item}) : super(key: key);

  @override
  State<ChangeFieldPage> createState() => _ChangeFieldPageState();
}

class _ChangeFieldPageState extends State<ChangeFieldPage> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // textController.text = widget.item['value'] ?? '';

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
            Spacer(),
            Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: body,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BoxIcon(
                iconPath: 'assets/icons/check.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44), vertical: 16),
        child: BoxInputField(
          controller: textController,
          placeholder: widget.item['placeholder'],
          title: widget.item['title'],
        ),
      ),
    );
  }
}