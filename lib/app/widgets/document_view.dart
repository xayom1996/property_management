import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentView extends StatefulWidget {
  final String documentUrl;
  final bool minimize;
  const DocumentView({Key? key, required this.documentUrl, this.minimize = false}) : super(key: key);

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  String url = '';

  void getUrl() async {
    url = await firebase_storage.FirebaseStorage.instance
        .ref(widget.documentUrl)
        .getDownloadURL();
    setState(() {});
  }

  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    getUrl();
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true || url == ''
      ? Center(
          child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator()
          ),
        )
      : PhotoView(
        imageProvider: NetworkImage(
          url,
        ),
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return url.contains('.pdf')
              ? SfPdfViewer.network(url)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/view_unavailable.svg',
                      height: 85,
                    ),
                    if (!widget.minimize)
                      Column(
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Просмотр недоступен',
                            style: body.copyWith(
                              color: Color(0xffC7C9CC),
                            ),
                          )
                        ],
                      ),
                  ],
                );
        },
        loadingBuilder: (context, progress) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                  progress.expectedTotalBytes!,
            ),
          ),
        ),
        backgroundDecoration: BoxDecoration(color: Colors.white),
        gaplessPlayback: false,
        // customSize: MediaQuery.of(context).size,
        // scaleStateChangedCallback: this.onScaleStateChanged,
        enableRotation: true,
        // controller:  controller,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
        // scaleStateCycle: scaleStateCycle
      );
  }
}