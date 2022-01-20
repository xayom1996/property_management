import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/objects/pages/upload_document_page.dart';
import 'package:property_management/objects/widgets/action_bottom_sheet.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';
import 'package:property_management/widgets/input_field.dart';

class ChangeFieldPage extends StatefulWidget {
  final String title;
  final Map? item;
  final List? items;
  ChangeFieldPage({Key? key, required this.title, this.item, this.items}) : super(key: key);

  @override
  State<ChangeFieldPage> createState() => _ChangeFieldPageState();
}

class _ChangeFieldPageState extends State<ChangeFieldPage> {
  bool hasDocument = false;
  String document = "";
  String checkedItem = '';

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
            if (widget.items != null)
              Column(
                children: [
                  for (var item in widget.items!)
                    ContainerForTransition(
                      title: item,
                      icon: checkedItem == item ? Icons.check : null,
                      onTap: () {
                        setState(() {
                          checkedItem = item;
                        });
                      },
                    ),
                ],
              ),
            if (widget.item != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoxInputField(
                    controller: textController,
                    placeholder: widget.item!['placeholder'],
                    title: widget.item!['title'],
                  ),
                  if (widget.item!['title'] == 'Площадь объекта' || widget.item!['title'] == 'Банковское обслуживание')
                    hasDocument == false
                        ? GestureDetector(
                      onTap: (){
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) => ActionBottomSheet(
                            onUploadFromDevice: () {
                              setState(() {
                                hasDocument = true;
                              });
                              Navigator.pop(context);
                            },
                            onUploadFromUrl: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UploadDocumentPage()),
                              );
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Spacer(),
                          SvgPicture.asset(
                            'assets/icons/document.svg',
                            color: Color(0xff4B81EF),
                            height: 16,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Добавить документ',
                            style: body.copyWith(
                              color: Color(0xff5589F1),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                        : Stack(
                          children: [
                            Container(
                              width: 138,
                              height: 138,
                            ),
                            Positioned(
                              top: 10,
                              left: 0,
                              child: Container(
                                height: 128,
                                width: 128,
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F7F9),
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/document.svg',
                                    color: Color(0xffE9ECEE),
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child:  GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hasDocument = false;
                                  });
                                },
                                child: BoxIcon(
                                  size: 24,
                                  iconSize: 12,
                                  iconPath: 'assets/icons/clear.svg',
                                  backgroundColor: Color(0xffE9ECEE),
                                  iconColor: Color(0xffC7C9CC),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}