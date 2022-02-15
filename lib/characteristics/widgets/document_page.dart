import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/document_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class DocumentPage extends StatelessWidget {
  final String documentUrl;
  const DocumentPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            Text('Документ',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/download.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () async {
                Directory? appDocDir = await getExternalStorageDirectory();
                String fileName = documentUrl.split('documents/').last;
                String ext = fileName.split('.').last;
                File downloadToFile = File('${appDocDir!.path}/$fileName');
                await firebase_storage.FirebaseStorage.instance
                    .ref(documentUrl)
                    .writeToFile(downloadToFile);
                Uint8List bytes = downloadToFile.readAsBytesSync();
                await FileSaver.instance.saveAs(fileName, bytes, ext, MimeType.OTHER);
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DocumentView(
            documentUrl: documentUrl,
          ),
        ),
      ),
    );
  }
}