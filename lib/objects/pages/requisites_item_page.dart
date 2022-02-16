import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/widgets/custom_checkbox.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/objects/cubit/add_object/add_object_cubit.dart';
import 'package:property_management/objects/pages/upload_document_page.dart';
import 'package:property_management/objects/widgets/action_bottom_sheet.dart';
import 'package:property_management/objects/widgets/document_card.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/input_field.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class RequisitesItemPage extends StatefulWidget {
  final Characteristics item;
  final Function onChange;
  RequisitesItemPage({Key? key, required this.item, required this.onChange}) : super(key: key);

  @override
  State<RequisitesItemPage> createState() => _RequisitesItemPageState();
}

class _RequisitesItemPageState extends State<RequisitesItemPage> {
  bool hasDocument = false;
  String documentUrl = "";
  bool loadingDocument = false;
  String checkedItem = '';
  late final TextEditingController textController1;
  late final TextEditingController textController2;
  late final TextEditingController textController3;
  late final TextEditingController textController4;

  @override
  void initState() {
    print(widget.item.details);
    if (widget.item.details!.isNotEmpty) {
      textController1 = TextEditingController(text: widget.item.details![0]);
      textController2 = TextEditingController(text: widget.item.details![1]);
      textController3 = TextEditingController(text: widget.item.details![2]);
      textController4 = TextEditingController(text: widget.item.details![3]);
    }
    if (widget.item.documentUrl != null && widget.item.documentUrl!.isNotEmpty) {
      documentUrl = widget.item.documentUrl!;
      hasDocument = true;
    }
    super.initState();
  }

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
                  widget.item.title,
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
                if (loadingDocument == true){
                  showSnackBar(context, 'Дождитесь загрузки документа...', color: Colors.blue);
                } else if (textController1.text.isEmpty || textController2.text.isEmpty
                || textController3.text.isEmpty || textController4.text.isEmpty) {
                  showSnackBar(context, 'Заполните все реквизиты');
                }
                else {
                  widget.onChange(
                      widget.item.id,
                      [
                        textController1.text,
                        textController2.text,
                        textController3.text,
                        textController4.text
                      ],
                      documentUrl,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoxInputField(
                                controller: textController1,
                                placeholder: 'Введите получателя',
                                title: 'Получатель',
                              ),
                              BoxInputField(
                                controller: textController2,
                                placeholder: 'Введите счет получателя',
                                title: 'Счет получателя',
                                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                                // isError: isError,
                              ),
                              BoxInputField(
                                controller: textController3,
                                placeholder: 'Введите БИК банка получателя',
                                title: 'БИК банка получателя',
                                // isError: isError,
                              ),
                              BoxInputField(
                                controller: textController4,
                                placeholder: 'Введите ИНН получателя',
                                title: 'ИНН получателя',
                                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                                // isError: isError,
                              ),
                              hasDocument == false
                                  ? GestureDetector(
                                onTap: (){
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) => ActionBottomSheet(
                                      onUploadFromDevice: () async {
                                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                                        if (result != null) {
                                          File file = File(result.files.first.path!);
                                          String fileName = result.files.first.name;

                                          setState(() {
                                            loadingDocument = true;
                                            hasDocument = true;
                                          });

                                          Navigator.pop(context);

                                          try {
                                            await firebase_storage.FirebaseStorage.instance
                                                .ref('documents/$fileName')
                                                .putFile(file);
                                            // String _documentUrl = await firebase_storage.FirebaseStorage.instance
                                            //     .ref('documents/$fileName')
                                            //     .getDownloadURL();
                                            setState(() {
                                              documentUrl = 'documents/$fileName';
                                            });
                                          } on firebase_core.FirebaseException catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: const Text('Произошла ошибка'),
                                              backgroundColor: Colors.red,
                                              action: SnackBarAction(
                                                label: '',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            ));
                                            setState(() {
                                              documentUrl = '';
                                              hasDocument = false;
                                            });
                                          } finally {
                                            setState(() {
                                              loadingDocument = false;
                                            });
                                          }

                                        } else {
                                          // User canceled the picker
                                        }
                                        // Navigator.pop(context);
                                      },
                                      onUploadFromUrl: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => UploadDocumentPage(
                                            onUpload: (String documentUrl) {
                                              setState(() {
                                                documentUrl = documentUrl;
                                                hasDocument = true;
                                              });
                                            },
                                          )),
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
                                  : DocumentCard(
                                      url: documentUrl,
                                      isLoading: loadingDocument,
                                      onDelete: (){
                                        setState(() {
                                          hasDocument = false;
                                          documentUrl = '';
                                        });
                                      }
                                  )
                            ],
                          ),
                      ],
                    ),
                  ),
              ),
            ],
          );
        },
      ),
    );
  }
}