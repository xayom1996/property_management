import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class UploadDocumentPage extends StatefulWidget {
  final Function onUpload;
  UploadDocumentPage({Key? key, required this.onUpload}) : super(key: key);

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  String errorMessage = '';
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  Future<Uint8List?> downloadFile(String url) async {
    HttpClient httpClient = new HttpClient();
    Uint8List? bytes;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(response.statusCode == 200) {
        bytes = await consolidateHttpClientResponseBytes(response);
      }
      else {
        throw Exception('Введите корректную ссылку');
      }
    }
    catch(ex){
      throw Exception('Введите корректную ссылку');
    }

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        // automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Загрузка документа',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/clear.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoxInputField(
                      controller: textController,
                      placeholder: 'site.com/doc.pdf',
                      title: 'Ссылка на документ',
                      isError: errorMessage.isNotEmpty,
                      errorText: errorMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw), vertical: 16),
              child: SizedBox(
                width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                child: BoxButton(
                  title: 'Загрузить',
                  busy: isLoading,
                  onTap: () async {
                    Uint8List? bytes;

                    setState(() {
                      errorMessage = '';
                      isLoading = true;
                    });

                    String fileName = textController.text.split('/').last;
                    String url = textController.text;

                    if (url.contains('drive.google')){
                      List lst = url.split('/');
                      String fileId = lst[lst.length - 2];
                      url = 'https://drive.google.com/uc?export=view&id=$fileId';
                      fileName = fileId;
                    }

                    try {
                      bytes = await downloadFile(url);
                    } catch (e) {
                      setState(() {
                        errorMessage = 'Введите корректную ссылку';
                      });
                    }
                    if (bytes != null) {
                      try {
                        await firebase_storage.FirebaseStorage.instance
                            .ref('documents/$fileName')
                            .putData(bytes);
                        Navigator.pop(context);
                        widget.onUpload('documents/$fileName');
                      } on firebase_core.FirebaseException catch (e) {
                        print(e);
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}