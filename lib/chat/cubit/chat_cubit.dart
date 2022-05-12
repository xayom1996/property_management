import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required AppBloc appBloc})
      : _appBloc = appBloc,
        super(ChatState()) {
          getListChats();
          _appBlocSubscription = _appBloc.stream.listen(
                (state){
              if (state.status != AppStatus.loading) {
                getListChats();
              }
            });
        }

  late final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void getListChats() async {
    emit(state.copyWith(
      status: ChatStateStatus.loading
    ));

    List<Chat> chats = await _appBloc.fireStoreService.getListChats(_appBloc.state.user);
    chats.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
      }

      if (a.lastMessage == null && b.lastMessage == null) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return a.lastMessage != null ? 0 : 1;
    });

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      chats: chats,
      status: ChatStateStatus.success,
      newMessages: newMessages,
    ));
  }

  // UploadTask uploadFile(File image, String fileName) {
  //   Reference reference = firebaseStorage.ref().child(fileName);
  //   UploadTask uploadTask = reference.putFile(image);
  //   return uploadTask;
  // }
  //
  // Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
  //   return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  // }

  void updateLastMessage(String chatId, MessageChat messageChat) {
    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);
    chats[index].lastMessage = messageChat;

    chats.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
      }

      if (a.lastMessage == null && b.lastMessage == null) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return a.lastMessage != null ? 0 : 1;
    });

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
      newMessages:newMessages,
    ));
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return _appBloc.fireStoreService.getChatStream(chatId, limit);
  }

  void sendMessage(String content, int type, String chatId, String currentUserId, String peerId, File? selectedFile) {
    _appBloc.fireStoreService.sendMessage(content, type, chatId, currentUserId, peerId, selectedFile);
  }

  void readMessages(String chatId) {
    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    _appBloc.fireStoreService.readMessages(chatId);

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);
    chats[index].unreadMessages = 0;

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
      newMessages: newMessages,
    ));
  }
}
