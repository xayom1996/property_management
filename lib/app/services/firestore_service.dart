import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/utils/cache.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';
import 'package:property_management/objects/models/place.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class FireStoreService {
  FireStoreService({
    CacheClient? cache,
    FirebaseFirestore? fireStore,
  })  : _cache = cache ?? CacheClient(),
        _fireStore = fireStore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _fireStore;

  // Future<void> addPlansCharacteristics() async {
  //   Map<String, dynamic> characteristics = {};
  //   for (var i = 0; i < planItems.length; i++) {
  //     characteristics[planItems[i]['title']] = {
  //       'id': i,
  //       'title': planItems[i]['title'],
  //       'placeholder': planItems[i]['placeholder'],
  //       'value': planItems[i]['value'],
  //       'type': planItems[i]['type'],
  //       'unit': planItems[i]['unit'],
  //     };
  //   }
  //   await _fireStore.collection('characteristics')
  //       .doc('plan_characteristics')
  //       .set(characteristics)
  //       .then((value) => print("plan_characteristics Added"))
  //       .catchError((error) => throw Exception('Error adding'));
  // }

  Future<List<Characteristics>> getCharacteristics(String docId) async {
    DocumentSnapshot objectCharacteristics = await _fireStore.collection('characteristics')
        .doc(docId)
        .get();
    var characteristics = objectCharacteristics.data() as Map<String, dynamic>;

    List<Characteristics> objectItems = List<Characteristics>.from(
        characteristics.values.map((item) => Characteristics.fromJson(item)));
    objectItems.sort((a, b) => a.id.compareTo(b.id));
    return objectItems;
  }

  Future<void> addObject({required List<Characteristics> filledItems}) async {
    List<dynamic> objectMap = [for (var item in filledItems) item.toJson()];

    await _fireStore.collection('new_objects')
        .add({
          'objectItems': objectMap,
          'createdDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        })
        .then((value) => print("Object Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addTenant({required List<Characteristics> tenantItems, required String docId}) async {
    List<dynamic> tenantMap = [for (var item in tenantItems) item.toJson()];

    DocumentSnapshot snapshot = await _fireStore.collection('new_objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;

    object['tenantItems'] = tenantMap;

    if (object['expensesItems'] != null) {
      for (var key in object['expensesItems'].keys){
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems'][10]['value'])
            && isNotEmpty(object['expensesItems'][key][5]['value'])) {
          try {
            object['expensesItems'][key][4]['value'] =
                double.parse(
                    object['expensesItems'][key][5]['value']) *
                    (100 - double.parse(
                        object['tenantItems'][10]['value'])) /
                    100;
            object['expensesItems'][key][4]['value'] =
                double.parse(object['expensesItems'][key][4]['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          object['expensesItems'][key][4]['value'] = '0';
        }
      }
    }
    await _fireStore.collection('new_objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Object Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addExpenseArticle({required List<Characteristics> expenseArticleItems, required String docId}) async {
    List<dynamic> expensesArticleMap = [for (var item in expenseArticleItems) item.toJson()];

    String startStr = expensesArticleMap[7]['value'] ?? '';
    String finishStr = expensesArticleMap[8]['value'] ?? '';
    if (startStr.isNotEmpty && finishStr.isNotEmpty) {
      DateTime start = DateFormat('dd.MM.yyyy').parse(startStr);
      DateTime finish = DateFormat('dd.MM.yyyy').parse(finishStr);
      if (start.isAtSameMomentAs(finish) || start.isAfter(finish)) {
        throw Exception('Дата конца расчета должна быть больше даты начала');
      }
    }

    await _fireStore.collection('new_objects')
        .doc(docId)
        .update({
          'expensesArticleItems': expensesArticleMap,
        })
        .then((value) => print("expensesArticleItems Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addExpense({required List<Characteristics> expenseItems,
    required String docId, int? monthIndex, List<Characteristics>? defaultExpenseItems}) async {
    List<dynamic> expensesMap = [for (var item in expenseItems) item.toJson()];
    print(expensesMap);
    DocumentSnapshot snapshot = await _fireStore.collection('new_objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> expensesItems = {};
    if (object['expensesItems'] != null) {
      expensesItems = object['expensesItems'];
    }
    if (object['tenantItems'] != null && isNotEmpty(object['tenantItems'][10]['value'])
        && isNotEmpty(expensesMap[5]['value'])) {
      try {
        expensesMap[4]['value'] =
            double.parse(expensesMap[5]['value']) *
                (100 - double.parse(object['tenantItems'][10]['value'])) / 100;
        expensesMap[4]['value'] = double.parse(expensesMap[4]['value'].toStringAsFixed(2)).toString();
      } catch(e) {
        print(e);
      }
    } else {
      expensesMap[4]['value'] = '0';
    }

    // List expensesDates = [for (var i = 0; i < expensesItems.values; i++) if (i != monthIndex) expensesItems.values[i][0]['value']];

    if (expensesItems.containsKey(expensesMap[0]['value']) && monthIndex == null){
      throw Exception('Эксплуатация за этот месяц уже существует');
    }

    if (monthIndex != null) {
      expensesItems[expensesMap[0]['value']] = expensesMap;
    } else {
      expensesItems[expensesMap[0]['value']] = expensesMap;

      DateTime newDate = DateTime.now();
      DateTime currentDate = DateFormat('MM.yyyy').parse(expensesMap[0]['value']);

      while (DateFormat('MM.yyyy').format(currentDate) != DateFormat('MM.yyyy').format(newDate)) {
        if (!expensesItems.containsKey(DateFormat('MM.yyyy').format(currentDate))
            && DateFormat('MM.yyyy').format(currentDate) != expensesMap[0]['value']){
          List<dynamic> defaultExpensesMap = [for (var item in defaultExpenseItems!) item.toJson()];
          defaultExpensesMap[0]['value'] = DateFormat('MM.yyyy').format(currentDate);
          expensesItems[defaultExpensesMap[0]['value']] = defaultExpensesMap;
        }
        if (newDate.isBefore(currentDate)) {
          currentDate = DateTime(currentDate.year, currentDate.month - 1);
        } else {
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }
      }

      if (!expensesItems.containsKey(DateFormat('MM.yyyy').format(currentDate))
          && DateFormat('MM.yyyy').format(currentDate) != expensesMap[0]['value']){
        List<dynamic> defaultExpensesMap = [for (var item in defaultExpenseItems!) item.toJson()];
        defaultExpensesMap[0]['value'] = DateFormat('MM.yyyy').format(currentDate);
        expensesItems[defaultExpensesMap[0]['value']] = defaultExpensesMap;
      }
    }

    await _fireStore.collection('new_objects')
        .doc(docId)
        .update({
          'expensesItems': expensesItems,
        })
        .then((value) => print("expensesItems Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addPlan({required List<Characteristics> planItems, required String docId, int? index, String? action}) async {
    List<dynamic> planMap = [for (var item in planItems) item.toJson()]; // 2016-01-25

    String startStr = planMap[3]['value'] ?? '';
    String finishStr = planMap[4]['value'] ?? '';
    if (startStr.isNotEmpty && finishStr.isNotEmpty) {
      DateTime start = DateFormat('dd.MM.yyyy').parse(startStr);
      DateTime finish = DateFormat('dd.MM.yyyy').parse(finishStr);
      if (start.isAtSameMomentAs(finish) || start.isAfter(finish)) {
        throw Exception('Дата конца расчета должна быть больше даты начала');
      }
    }

    String str = planMap[10]['value'] ?? '';
    if (str.isEmpty) {
      planMap[10]['value'] = '0';
    }

    DocumentSnapshot snapshot = await _fireStore.collection('new_objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> plansItems = {};
    if (object['plansItems'] != null) {
      plansItems = object['plansItems'];
    }
    if (index != null) {
      if (action == 'edit') {
        plansItems[index.toString()] = planMap;
      }
      if (action == 'delete') {
        int planIndex = index;
        while (plansItems.containsKey((planIndex + 1).toString())) {
          plansItems[planIndex.toString()] = plansItems[(planIndex + 1).toString()];
          planIndex = planIndex + 1;
        }
        plansItems.remove(planIndex.toString());
      }
    } else {
      plansItems[plansItems.values.length.toString()] = planMap;
    }

    await _fireStore.collection('new_objects')
        .doc(docId)
        .update({
          'plansItems': plansItems,
        })
        .then((value) => print("PlanItems Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> editObject({required List<Characteristics> filledItems, required String docId}) async {
    List<dynamic> objectMap = [for (var item in filledItems) item.toJson()];
    await _fireStore.collection('new_objects')
        .doc(docId)
        .update({
          'objectItems': objectMap,
        })
        .then((value) => print("Object updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> editTenant({required List<Characteristics> filledItems, required String docId}) async {
    List<dynamic> tenantMap = [for (var item in filledItems) item.toJson()]; // 2016-01-25

    DocumentSnapshot snapshot = await _fireStore.collection('new_objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;

    object['tenantItems'] = tenantMap;

    if (object['expensesItems'] != null) {
      List<dynamic> expensesItems = object['expensesItems'].values.toList();

      for (var i = 0; i < expensesItems.length; i++){
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems'][10]['value'])
            && isNotEmpty(expensesItems[i][5]['value'])) {
          try {
            expensesItems[i][4]['value'] =
                double.parse(
                    expensesItems[i][5]['value']) *
                    (100 - double.parse(
                        object['tenantItems'][10]['value'])) /
                    100;
            expensesItems[i][4]['value'] =
                double.parse(expensesItems[i][4]['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          expensesItems[i][4]['value'] = '0';
        }
      }
    }
    await _fireStore.collection('new_objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Object Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> updateColorObject({required String docId, required String value}) async {
    DocumentSnapshot snapshot = await _fireStore.collection('new_objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;
    object['tenantItems'][12]['value'] = value;

    await _fireStore.collection('new_objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Color Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> deleteObject(String docId) async {
    await _fireStore.collection('new_objects')
        .doc(docId)
        .delete()
        .then((value) => print("Object deleted"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<List<Place>> getObjects(User user, List<String> owners) async {
    QuerySnapshot querySnapshot;
    querySnapshot = await _fireStore.collection('new_objects').get();
    // if (user.role == 'admin') {
    //   querySnapshot = await _fireStore.collection('new_objects').get();
    // } else {
    //   querySnapshot = await _fireStore.collection('new_objects').where('objectItems.3.value', whereIn: owners).get();
    // }

    List<Place> places = [];
    for (var doc in querySnapshot.docs) {
      var place = doc.data() as Map<String, dynamic>;
      place['id'] = doc.id;
      place['expensesItems'] = (place['expensesItems'] ?? {}).values;
      place['plansItems'] = (place['plansItems'] ?? {}).values;

      if (!owners.contains(place['objectItems'][3]['value'])){
        continue;
      }

      double sumTaxes = 0;
      double sumCurrentRent = 0;
      for (var item in place['expensesItems'] ?? []) {
        if (item[0]['value'] == DateFormat('MM.yyyy').format(DateTime.now())) {
          if (place['tenantItems'] != null) {
            place['tenantItems'][2]['value'] = item[1]['value'];
          }
          if (place['objectItems'] != null) {
            if (place['objectItems'][14]['value'] == null
                || place['objectItems'][14]['value'] == '') {
              place['objectItems'][14]['value'] =
              item[1]['value'];
            }
          }
        }

        /// Сумма налогов и арендной платы за последний год
        DateTime date = DateFormat('MM.yyyy').parse(item[0]['value']);
        DateTime now = DateTime.now();
        if (date.isAfter(DateTime(now.year - 1, now.month, now.day))
            && date.isBefore(now)){
          if (item[3]['value'] != null && item[3]['value'] != '') {
            sumTaxes = sumTaxes + double.parse(item[3]['value']);
          }
          if (item[1]['value'] != null
              && item[1]['value'] != '') {
            sumCurrentRent = sumCurrentRent +
                double.parse(item[1]['value']);
          }
        }
      }

      place['objectItems'][8]['value'] = null;
      if (place['objectItems'][14]['value'] != null
          && place['objectItems'][14]['value'] != '') {
        if (place['objectItems'][15]['value'] != null
            && place['objectItems'][15]['value'] != '') {
          place['objectItems'][8]['value'] =
              removeTrailingZeros((double.parse(place['objectItems'][14]['value']) /
                  (double.parse(
                      place['objectItems'][15]['value']) / 100)).toStringAsFixed(2));
        }
      }

      if (sumCurrentRent != 0 && sumTaxes != 0) {
        if (place['objectItems'] != null) {
          place['objectItems'][13]['value'] = double.parse((sumTaxes / sumCurrentRent).toStringAsFixed(2)).toString();
        }
      }
      places.add(Place.fromJson(place));
    }
    return places;
  }

  Future<Map<String, Map<String, List<Characteristics>>>> getOwners(User user) async {
    QuerySnapshot querySnapshot;
    if (user.role == 'admin') {
      querySnapshot = await _fireStore.collection('owners').get();
    }else if (user.role == 'manager') {
      querySnapshot = await _fireStore.collection('owners').where('managers', arrayContains: user.email).get();
    } else {
      querySnapshot = await _fireStore.collection('owners').where('holders', arrayContains: user.email).get();
    }

    List<Characteristics> objectItems = await getCharacteristics('object_characteristics');
    List<Characteristics> tenantItems = await getCharacteristics('tenant_characteristics');
    List<Characteristics> expensesItems = await getCharacteristics('expense_characteristics');
    List<Characteristics> expensesArticleItems = await getCharacteristics('expense_article_characteristics');

    Map<String, Map<String, List<Characteristics>>> owners = {};
    for (var doc in querySnapshot.docs) {
      var owner = (doc.data() as Map<String, dynamic>);
      String ownerName = owner['name'];
      Map<String, List<Characteristics>> ownerCharacteristics;
      if (owner['characteristics'] != null) {
        ownerCharacteristics = Map.from(
            owner['characteristics'].map((key, value) =>
                MapEntry(key, List<Characteristics>.from(value.map((characteristic) => Characteristics.fromJson(characteristic))))));
      } else {
        await _fireStore.collection('owners')
            .doc(doc.reference.id)
            .update({
              'characteristics': {
                'object_characteristics': List.from(objectItems.map((item) => item.toJson())),
                'tenant_characteristics': List.from(tenantItems.map((item) => item.toJson())),
                'expense_characteristics': List.from(expensesItems.map((item) => item.toJson())),
                'expense_article_characteristics': List.from(expensesArticleItems.map((item) => item.toJson())),
              },
            })
            .then((value) => print("Updated"));

        ownerCharacteristics = {
          'object_characteristics': objectItems,
          'tenant_characteristics': tenantItems,
          'expense_characteristics': expensesItems,
          'expense_article_characteristics': expensesArticleItems,
        };
      }

      owners[ownerName] = ownerCharacteristics;
    }
    return owners;
  }

  Future<void> saveCharacteristic({required List<Characteristics> characteristics,
    required String ownerName, required String characteristicsName}) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('owners').where('name', isEqualTo: ownerName).get();
    String docId = querySnapshot.docs.first.reference.id;

    QuerySnapshot objects = await _fireStore.collection('new_objects').get();

    for (var snapshot in objects.docs) {
      var object = snapshot.data() as Map<String, dynamic>;

      if (object['objectItems'][3]['value'] != ownerName) {
        continue;
      }
      List<dynamic> newItemsMap = [for (var item in characteristics) item.toJson()];

      if (characteristicsName == 'object_characteristics') {
        for (var item in object['objectItems']) {
          int index = characteristics.lastIndexWhere((element) => element.id == item['id']);
          if (index != -1) {
            newItemsMap[index]['value'] = item['value'];

            newItemsMap[index]['details'] = item['details'];
          }
        }
        object['objectItems'] = newItemsMap;
      }

      if (characteristicsName == 'tenant_characteristics'
          && object['tenantItems'] != null) {
        for (var item in object['tenantItems']) {
          int index = characteristics.lastIndexWhere((element) => element.id == item['id']);
          if (index != -1) {
            newItemsMap[index]['value'] = item['value'];

            newItemsMap[index]['details'] = item['details'];
          }
        }
        object['tenantItems'] = newItemsMap;
      }

      if (characteristicsName == 'expense_characteristics'
          && object['expensesItems'] != null) {
        Map<String, dynamic> expensesItems = {};
        for (var items in object['expensesItems'].values) {
          newItemsMap = [for (var item in characteristics) item.toJson()];

          for (var item in items) {
            int index = characteristics.lastIndexWhere((element) =>
            element.id == item['id']);
            if (index != -1) {
              newItemsMap[index]['value'] = item['value'];

              newItemsMap[index]['details'] = item['details'];
            }
          }
          expensesItems[newItemsMap[0]['value']] = newItemsMap;
        }
        object['expensesItems'] = expensesItems;
      }

      if (characteristicsName == 'expense_article_characteristics'
          && object['expensesArticleItems'] != null) {
        for (var item in object['expensesArticleItems']) {
          int index = characteristics.lastIndexWhere((element) => element.id == item['id']);
          if (index != -1) {
            newItemsMap[index]['value'] = item['value'];

            newItemsMap[index]['details'] = item['details'];
          }
        }
        object['expensesArticleItems'] = newItemsMap;
      }

      await _fireStore.collection('new_objects')
          .doc(snapshot.reference.id)
          .update(object)
          .then((value) => print("Object Updated"))
          .catchError((error) => throw Exception('Error adding'));
    }

    await _fireStore.collection('owners')
        .doc(docId)
        .update({
          'characteristics.$characteristicsName': List.from(characteristics.map((item) => item.toJson())),
        })
        .then((value) => print("Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return _fireStore
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: true)
        // .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String chatId, String currentUserId, String peerId, String fileUrl) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DocumentReference documentReference = _fireStore
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(timestamp.toString());

    if (content.trim().replaceAll(' ', '').isNotEmpty) {
      MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: timestamp.toString(),
        content: content,
        type: type,
        read: false,
      );

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          messageChat.toJson(),
        );
      });
    }

    if (fileUrl.isNotEmpty) {
      MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: (timestamp + 1000).toString(),
        content: fileUrl,
        type: 1,
        read: false,
      );

      DocumentReference documentReference1 = _fireStore
          .collection('messages')
          .doc(chatId)
          .collection(chatId)
          .doc((timestamp + 1000).toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference1,
          messageChat.toJson(),
        );
      });
    }
  }

  Future<List<Chat>> getListChats(User currentUser) async {
    List<Chat> chats = [];
    List<User> users = [];
    QuerySnapshot querySnapshot;
    if (currentUser.role == 'admin') {
      querySnapshot = await _fireStore.collection('users').where('role', whereIn: ['admin', 'manager']).get();
      users += List.from(querySnapshot.docs.map((e) => User.fromJson(e.data() as Map<String, dynamic>)));
      users.removeAt(users.lastIndexWhere((element) => element.email == currentUser.email));
    } else if (currentUser.role == 'manager') {
      querySnapshot = await _fireStore.collection('users').where('role', isEqualTo: 'admin').get();
      users += List.from(querySnapshot.docs.map((e) => User.fromJson(e.data() as Map<String, dynamic>)));
      QuerySnapshot ownersQuerySnapshot = await _fireStore.collection('owners').where('managers', arrayContains: currentUser.email).get();
      List owners = [];
      for (var owner in ownersQuerySnapshot.docs) {
        owners = owner['holders'];

        querySnapshot = await _fireStore.collection('users')
            .where('email', whereIn: owners)
            .get();
        List<User> userOwners = List.from(querySnapshot.docs.map((e) =>
            User.fromJson(e.data() as Map<String, dynamic>)));

        chats += List<Chat>.from(userOwners.map((user) => Chat(
            name: user.getFullName(),
            role: owner['name'],
            chatId: getChatId(currentUser.id, user.id),
            currentUserId: currentUser.id,
            peerId: user.id
        )));
      }
    } else if (currentUser.role == 'owner') {
      QuerySnapshot ownersQuerySnapshot = await _fireStore.collection('owners')
          .where('holders', arrayContains: currentUser.email)
          .get();
      List managers = [];
      for (var owner in ownersQuerySnapshot.docs) {
        managers = managers + owner['managers'];
      }
      if (managers.isNotEmpty) {
        querySnapshot = await _fireStore.collection('users')
            .where('email', whereIn: managers)
            .get();
        users += List.from(querySnapshot.docs.map((e) =>
            User.fromJson(e.data() as Map<String, dynamic>)));
      }
    }

    chats += List<Chat>.from(users.map((user) => Chat(
      name: user.getFullName(),
      role: user.role,
      chatId: getChatId(currentUser.id, user.id),
      currentUserId: currentUser.id,
      peerId: user.id
    )));

    for (var chat in chats ) {
      QuerySnapshot querySnapshot = await _fireStore
          .collection('messages')
          .doc(chat.chatId)
          .collection(chat.chatId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        chat.lastMessage = MessageChat.fromDocument(querySnapshot.docs.first);
        if (chat.lastMessage!.idFrom != currentUser.id) {
          QuerySnapshot unreadMessages = await _fireStore
              .collection('messages')
              .doc(chat.chatId)
              .collection(chat.chatId)
              .where('read', isEqualTo: false)
              .get();
          chat.unreadMessages = unreadMessages.docs.length;
        }
      }
    }

    return chats;
  }

  void readMessages(String chatId) async {
    QuerySnapshot querySnapshots = await _fireStore
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .where('read', isEqualTo: false)
        .get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'read': true,
      });
    }
  }

}