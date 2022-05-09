import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/chat/cubit/chat_cubit.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  List<QueryDocumentSnapshot> listMessage = [];

  void onSendMessage() {
    if (textEditingController.text.trim() != '') {
      context.read<ChatCubit>().sendMessage(
          textEditingController.text, 0, widget.chat.chatId,
          widget.chat.currentUserId, widget.chat.peerId);
    }
    textEditingController.clear();
  }

  void onUploadFile () async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.first.path!);
      String fileName = result.files.first.name;

      Navigator.pop(context);

      // try {
      //   await firebase_storage.FirebaseStorage.instance
      //       .ref('documents/$fileName')
      //       .putFile(file);
      //   // String _documentUrl = await firebase_storage.FirebaseStorage.instance
      //   //     .ref('documents/$fileName')
      //   //     .getDownloadURL();
      //   setState(() {
      //     documentUrl = 'documents/$fileName';
      //   });
      // } on firebase_core.FirebaseException catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: const Text('Произошла ошибка'),
      //     backgroundColor: Colors.red,
      //     action: SnackBarAction(
      //       label: '',
      //       textColor: Colors.white,
      //       onPressed: () {
      //         // Some code to undo the change.
      //       },
      //     ),
      //   ));
      //   setState(() {
      //     documentUrl = '';
      //     hasDocument = false;
      //   });
      // } finally {
      //   setState(() {
      //     loadingDocument = false;
      //   });
      // }

    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
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
            Text(widget.chat.name,
              style: body,
            ),
            Spacer(),
            Container(
              height: 44,
              width: 44,
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(context),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            // buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Future<bool> onBackPress() {
    // chatProvider.updateDataFirestore(
    //   FirestoreConstants.pathUserCollection,
    //   currentUserId,
    //   {FirestoreConstants.chattingWith: null},
    // );
    Navigator.pop(context);

    return Future.value(false);
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          // Button send image
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 1),
          //     child: IconButton(
          //       icon: Icon(Icons.image),
          //       onPressed: () {},
          //       // onPressed: getImage,
          //       color: Colors.black,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),

          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                textInputAction: TextInputAction.search,
                autofocus: true,
                onTap: () {},
                controller: textEditingController,
                onChanged: (text) {
                  // changedSearchText(text);
                },
                style: const TextStyle(
                  color: Color(0xff151515),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF5F7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                    borderRadius: BorderRadius.all(
                        Radius.circular(60) //                 <--- border radius here
                    ),
                  ),
                  // prefixIconConstraints: BoxConstraints(maxWidth: 32),
                  hintText: 'Напишите сообщение',
                  hintStyle: body.copyWith(
                    color: Color(0xffC7C9CC),
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: onUploadFile,
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: BoxIcon(
                iconPath: 'assets/icons/forward.svg',
                iconColor: Colors.white,
                // iconSize: 20,
                size: 56,
                backgroundColor: Color(0xff5589F1),
                onTap: onSendMessage,
              ),
              // child: IconButton(
              //   icon: Icon(Icons.send),
              //   onPressed: (){},
              //   // onPressed: () => onSendMessage(textEditingController.text, TypeMessage.text),
              //   color: Colors.red,
              // ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 70,
      // decoration: BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage(BuildContext context) {
    return Flexible(
      child: 1 == 1
          ? StreamBuilder<QuerySnapshot>(
              stream: context.read<ChatCubit>().getChatStream(widget.chat.chatId, 10),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    MessageChat lastMessage = MessageChat.fromDocument(listMessage.first);
                    context.read<ChatCubit>().updateLastMessage(widget.chat.chatId, lastMessage);

                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: buildItem(index, snapshot.data?.docs[index])
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(child: Text("Нет сообщений..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document == null) {
      return SizedBox.shrink();
    }

    MessageChat messageChat = MessageChat.fromDocument(document);
    Alignment alignment;
    if (messageChat.idFrom == widget.chat.currentUserId) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }

    return Stack(
      children: [
        Align(
          alignment: alignment,
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minWidth: 60,
            ),
            decoration: BoxDecoration(
              color: alignment == Alignment.centerLeft
                  ? Color(0xff5589F1)
                  : Color(0xffF5F7F9),
              borderRadius: BorderRadius.all(
                  Radius.circular(16) //                 <--- border radius here
              ),
            ),
            child: Stack(
              children: [
                Text(
                  '${messageChat.content}\n',
                  style: body.copyWith(
                    color: alignment == Alignment.centerLeft
                        ? Color(0xffFCFCFC)
                        : Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    messageChat.getTime(),
                    style: caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget buildItem(Alignment alignment) {
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: alignment,
  //         child: Container(
  //           padding: EdgeInsets.all(16),
  //           constraints: BoxConstraints(
  //             maxWidth: MediaQuery.of(context).size.width * 0.65
  //           ),
  //           decoration: BoxDecoration(
  //             color: alignment == Alignment.centerLeft
  //                 ? Color(0xff5589F1)
  //                 : Color(0xffF5F7F9),
  //             borderRadius: BorderRadius.all(
  //                 Radius.circular(16) //                 <--- border radius here
  //             ),
  //           ),
  //           child: Stack(
  //             children: [
  //               Text(
  //                 'Здравствуйте! У меня возникли вопросы.\n',
  //                 style: body.copyWith(
  //                   color: alignment == Alignment.centerLeft
  //                       ? Color(0xffFCFCFC)
  //                       : Colors.black,
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 0,
  //                 right: 0,
  //                 child: Text(
  //                   '11:45',
  //                   style: caption,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
