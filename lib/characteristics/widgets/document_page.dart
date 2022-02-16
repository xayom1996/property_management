import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/document_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DocumentPage extends StatefulWidget {
  final String documentUrl;
  const DocumentPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  bool isDownloadingFile = false;

  void downloadFile() async {
    setState(() {
      isDownloadingFile = true;
    });
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();
    String fileName = widget.documentUrl.split('documents/').last;
    String ext = fileName.split('.').last;
    File downloadToFile = File('${appDocDir!.path}/$fileName');
    await firebase_storage.FirebaseStorage.instance
        .ref(widget.documentUrl)
        .writeToFile(downloadToFile);
    Uint8List bytes = downloadToFile.readAsBytesSync();
    setState(() {
      isDownloadingFile = false;
    });
    await FileSaver.instance.saveAs(fileName, bytes, ext, MimeType.OTHER)
        .then((value) => print(value));
    // try{
    //
    // } catch(e) {
    //   String url = await firebase_storage.FirebaseStorage.instance
    //       .ref(widget.documentUrl)
    //       .getDownloadURL();
    //   await launch(url);
    // } finally {
    //   setState(() {
    //     isDownloadingFile = false;
    //   });
    // }
  }

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
              isLoading: isDownloadingFile,
              onTap: !isDownloadingFile
                  ? downloadFile
                  : null,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DocumentView(
            documentUrl: widget.documentUrl,
          ),
        ),
      ),
    );
  }
}