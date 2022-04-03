import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
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

class ItemPage extends StatefulWidget {
  final Characteristics item;
  final Function onChange;
  ItemPage({Key? key, required this.item, required this.onChange}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool hasDocument = false;
  String documentUrl = "";
  bool loadingDocument = false;
  String checkedItem = '';

  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController(text: widget.item.value);
    checkedItem = widget.item.value ?? '';
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
              onTap: () async {
                if (loadingDocument == true){
                  showSnackBar(context, 'Дождитесь загрузки документа...', color: Colors.blue);
                } else {
                  widget.onChange(
                      widget.item.id, textController.text, documentUrl);
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
                        widget.item.title == 'Собственник' || widget.item.choices!.isNotEmpty
                        ? Column(
                            children: [
                              if (widget.item.title == 'Собственник')
                                for (var item in state.owners)
                                  ContainerForTransition(
                                    title: item,
                                    icon: checkedItem == item ? Icons.check : null,
                                    onTap: () {
                                      textController.text = item;
                                      setState(() {
                                        checkedItem = item;
                                      });
                                    },
                                  ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget.item.isDate()) {
                                    DateTime maxTime = DateTime(2025, 12, 31);
                                    DateTime minTime = DateTime(2000, 1, 1);
                                    if (widget.item.title == 'Месяц, Год'){
                                      maxTime = DateTime(DateTime.now().year + 1, 12, 31);
                                      minTime = DateTime(DateTime.now().year - 1, 1, 1);
                                    }
                                    DatePicker.showPicker(context,
                                        showTitleActions: true,
                                        onConfirm: (date) {
                                          setState(() {
                                            if (widget.item.title == 'Месяц, Год'){
                                              textController.text =
                                                  DateFormat('MM.yyyy')
                                                      .format(date);
                                            } else {
                                              textController.text =
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(date);
                                            }
                                          });
                                        },
                                        pickerModel: CustomPicker(
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.ru,
                                          maxTime: maxTime,
                                          minTime: minTime,
                                        ),
                                        locale: LocaleType.ru
                                    );
                                  }
                                },
                                child: BoxInputField(
                                  controller: textController,
                                  // autoFocus: true,
                                  placeholder: widget.item.placeholder ?? '',
                                  title: widget.item.title,
                                  enabled: !widget.item.isDate(),
                                  disableSpace: widget.item.type == 'Число',
                                  keyboardType: widget.item.title == 'Номер телефона'
                                    ? TextInputType.phone
                                      : widget.item.type == 'Число'
                                          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                                          : null,
                                ),
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
                                            },
                                            onUploadFromUrl: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UploadDocumentPage(
                                                  onUpload: (String _documentUrl) {
                                                    print(documentUrl);
                                                    setState(() {
                                                      hasDocument = true;
                                                      documentUrl = _documentUrl;
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
                                      key: UniqueKey(),
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

class CustomPicker extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    required LocaleType locale
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2025, 12, 31);
    this.minTime = minTime ?? DateTime(2000, 1, 1);
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.day);
    this.setMiddleIndex(this.currentTime.month);
    this.setRightIndex(this.currentTime.year);
  }

  @override
  String? leftStringAtIndex(int index) {
    int maxDays = DateTime(this.currentRightIndex(), this.currentMiddleIndex() + 1, 0).day;
    if (index >= 1 && index <= maxDays) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 1 && index <= 12) {
      return months[index - 1];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= minTime.year && index <= maxTime.year) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return DateTime.utc(this.currentRightIndex(), this.currentMiddleIndex(), this.currentLeftIndex());
  }
}