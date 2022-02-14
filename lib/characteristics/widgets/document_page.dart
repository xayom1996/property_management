import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  BoxIcon(
                    iconPath: 'assets/icons/download.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                    onTap: () async {
                      // Directory? appDocDir = await getExternalStorageDirectory();
                      // String fileName = documentUrl.split('documents/').last;
                      // String ext = fileName.split('.').last;
                      // print('${appDocDir!.path}/$fileName');
                      // File downloadToFile = File('${appDocDir.path}/$fileName');
                      // await firebase_storage.FirebaseStorage.instance
                      //     .ref(documentUrl)
                      //     .writeToFile(downloadToFile);

                      // await FileSaver.instance.saveAs(fileName, downloadToFile.readAsBytes(), ext, MimeType.PDF);
                      // File file;
                      // file.writeAsBytes([]);

                      // if (outputFile == null) {
                      //   // User canceled the picker
                      // }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              expandedHeight: 68,
              toolbarHeight: 68,
              collapsedHeight: 68,
              pinned: true,
              backgroundColor: kBackgroundColor,
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.all(24),
                  title: Text('Документ',
                    style: body,
                  ),
                );
              })
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: DocumentView(documentUrl: documentUrl),
            ),
          ),
        ],
      ),
    );
  }
}