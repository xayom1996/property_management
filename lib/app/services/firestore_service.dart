import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/utils/cache.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/objects/models/place.dart';

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
    Map<String, dynamic> objectMap = {for (var item in filledItems) item.title : item.toJson()}; // 2016-01-25
    await _fireStore.collection('objects')
        .add({
          'objectItems': objectMap,
          'createdDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        })
        .then((value) => print("Object Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addTenant({required List<Characteristics> tenantItems, required String docId}) async {
    Map<String, dynamic> tenantMap = {for (var item in tenantItems) item.title : item.toJson()}; // 2016-01-25

    DocumentSnapshot snapshot = await _fireStore.collection('objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;

    object['tenantItems'] = tenantMap;

    if (object['expensesItems'] != null) {
      for (var i = 0; i < object['expensesItems'].length; i++){
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems'][10]['value'])
            && isNotEmpty(object['expensesItems'][i][5]['value'])) {
          try {
            object['expensesItems'][i][4]['value'] =
                double.parse(
                    object['expensesItems'][i][5]['value']) *
                    (100 - double.parse(
                        object['tenantItems'][10]['value'])) /
                    100;
            object['expensesItems'][i][4]['value'] =
                double.parse(object['expensesItems'][i][4]['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          object['expensesItems'][i][4]['value'] = '0';
        }
      }
    }
    await _fireStore.collection('objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Object Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addExpenseArticle({required List<Characteristics> expenseArticleItems, required String docId}) async {
    Map<String, dynamic> expensesArticleMap = {for (var item in expenseArticleItems) item.title : item.toJson()};

    String startStr = expensesArticleMap[7]['value'] ?? '';
    String finishStr = expensesArticleMap[8]['value'] ?? '';
    if (startStr.isNotEmpty && finishStr.isNotEmpty) {
      DateTime start = DateFormat('dd.MM.yyyy').parse(startStr);
      DateTime finish = DateFormat('dd.MM.yyyy').parse(finishStr);
      if (start.isAtSameMomentAs(finish) || start.isAfter(finish)) {
        throw Exception('Дата конца расчета должна быть больше даты начала');
      }
    }

    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'expensesArticleItems': expensesArticleMap,
        })
        .then((value) => print("expensesArticleItems Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> addExpense({required List<Characteristics> expenseItems,
    required String docId, int? monthIndex, List<Characteristics>? defaultExpenseItems}) async {
    Map<String, dynamic> expensesMap = {for (var item in expenseItems) item.title : item.toJson()};
    DocumentSnapshot snapshot = await _fireStore.collection('objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;
    List expensesItems = [];
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

    List expensesDates = [for (var i = 0; i < expensesItems.length; i++) if (i != monthIndex) expensesItems[i][0]['value']];

    if (expensesDates.contains(expensesMap[0]['value'])){
      throw Exception('Эксплуатация за этот месяц уже существует');
    }

    if (monthIndex != null) {
      expensesItems[monthIndex] = expensesMap;
    } else {
      expensesItems.add(expensesMap);

      DateTime newDate = DateTime.now();
      DateTime currentDate = DateFormat('MM.yyyy').parse(expensesMap[0]['value']);

      while (DateFormat('MM.yyyy').format(currentDate) != DateFormat('MM.yyyy').format(newDate)) {
        if (!expensesDates.contains(DateFormat('MM.yyyy').format(currentDate))
            && DateFormat('MM.yyyy').format(currentDate) != expensesMap[0]['value']){
          Map<String, dynamic> defaultExpensesMap = {for (var item in defaultExpenseItems!) item.title : item.toJson()};
          defaultExpensesMap[0]['value'] = DateFormat('MM.yyyy').format(currentDate);
          expensesItems.add(defaultExpensesMap);
        }
        if (newDate.isBefore(currentDate)) {
          currentDate = DateTime(currentDate.year, currentDate.month - 1);
        } else {
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }
      }

      if (!expensesDates.contains(DateFormat('MM.yyyy').format(currentDate))
          && DateFormat('MM.yyyy').format(currentDate) != expensesMap[0]['value']){
        Map<String, dynamic> defaultExpensesMap = {for (var item in defaultExpenseItems!) item.title : item.toJson()};
        defaultExpensesMap[0]['value'] = DateFormat('MM.yyyy').format(currentDate);
        expensesItems.add(defaultExpensesMap);
      }
    }

    await _fireStore.collection('objects')
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

    DocumentSnapshot snapshot = await _fireStore.collection('objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;
    List plansItems = [];
    if (object['plansItems'] != null) {
      plansItems = object['plansItems'];
    }
    if (index != null) {
      if (action == 'edit') {
        plansItems[index] = planMap;
      }
      if (action == 'delete') {
        plansItems.removeAt(index);
      }
    } else {
      plansItems.add(planMap);
    }

    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'plansItems': plansItems,
        })
        .then((value) => print("PlanItems Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> editObject({required List<Characteristics> filledItems, required String docId}) async {
    List<dynamic> objectMap = [for (var item in filledItems) item.toJson()];
    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'objectItems': objectMap,
        })
        .then((value) => print("Object updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> editTenant({required List<Characteristics> filledItems, required String docId}) async {
    List<dynamic> tenantMap = [for (var item in filledItems) item.toJson()]; // 2016-01-25

    DocumentSnapshot snapshot = await _fireStore.collection('objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;

    object['tenantItems'] = tenantMap;

    if (object['expensesItems'] != null) {
      for (var i = 0; i < object['expensesItems'].length; i++){
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems'][10]['value'])
            && isNotEmpty(object['expensesItems'][i][5]['value'])) {
          try {
            object['expensesItems'][i][4]['value'] =
                double.parse(
                    object['expensesItems'][i][5]['value']) *
                    (100 - double.parse(
                        object['tenantItems'][10]['value'])) /
                    100;
            object['expensesItems'][i][4]['value'] =
                double.parse(object['expensesItems'][i][4]['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          object['expensesItems'][i][4]['value'] = '0';
        }
      }
    }
    await _fireStore.collection('objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Object Updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> updateColorObject({required String docId, required String value}) async {
    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'tenantItems.12.value': value,
        })
        .then((value) => print("Object updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> deleteObject(String docId) async {
    await _fireStore.collection('objects')
        .doc(docId)
        .delete()
        .then((value) => print("Object deleted"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<List<Place>> getObjects(User user, List<String> owners) async {
    QuerySnapshot querySnapshot;
    if (user.role == 'admin') {
      querySnapshot = await _fireStore.collection('objects').get();
    } else {
      querySnapshot = await _fireStore.collection('objects').where('objectItems.3.value', whereIn: owners).get();
    }
    print(querySnapshot.docs.length);
    List<Place> places = querySnapshot.docs.map((doc) {
      var place = doc.data() as Map<String, dynamic>;
      var objectItems = place['objectItems'].values.toList();
      objectItems.sort((a, b) {
        if(a['id'] > b['id']) {
          return 1;
        }
        return -1;
      });
      place['objectItems'] = objectItems;
      if (place['tenantItems'] != null) {
        var tenantItems = place['tenantItems'].values.toList();
        tenantItems.sort((a, b) {
          if (a['id'] > b['id']) {
            return 1;
          }
          return -1;
        });
        place['tenantItems'] = tenantItems;
      }

      if (place['expensesArticleItems'] != null) {
        var expensesArticleItems = place['expensesArticleItems'].values
            .toList();
        expensesArticleItems.sort((a, b) {
          if (a['id'] > b['id']) {
            return 1;
          }
          return -1;
        });
        place['expensesArticleItems'] = expensesArticleItems;
      }

      if (place['expensesItems'] != null) {
        var expensesItems = place['expensesItems'].toList();
        for (var i = 0; i < expensesItems.length; i++) {
          var items = expensesItems[i].values.toList();
          items.sort((a, b) {
            if (a['id'] > b['id']) {
              return 1;
            }
            return -1;
          });
          expensesItems[i] = items;
        }
        place['expensesItems'] = expensesItems;
      }

      if (place['planItems'] != null) {
        var planItems = place['planItems'].toList();
        for (var i = 0; i < planItems.length; i++) {
          var items = planItems[i].values.toList();
          items.sort((a, b) {
            if (a['id'] > b['id']) {
              return 1;
            }
            return -1;
          });
          planItems[i] = items;
        }
        place['planItems'] = planItems;
      }
      
      place['id'] = doc.id;

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
      return Place.fromJson(place);
    }).toList();
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

    QuerySnapshot objects = await _fireStore.collection('objects').where('objectItems.3.value', isEqualTo: ownerName).get();
    for (var snapshot in objects.docs) {
      var object = snapshot.data() as Map<String, dynamic>;
      List<dynamic> newItemsMap = [for (var item in characteristics) item.toJson()];

      if (characteristicsName == 'object_characteristics') {
        for (var item in object['objectItems'].values) {
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
        for (var item in object['tenantItems'].values) {
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
        List expensesItems = [];
        for (var items in object['expensesItems']) {
          newItemsMap = [for (var item in characteristics) item.toJson()];

          for (var item in items.values) {
            int index = characteristics.lastIndexWhere((element) =>
            element.id == item['id']);
            if (index != -1) {
              newItemsMap[index]['value'] = item['value'];

              newItemsMap[index]['details'] = item['details'];
            }
          }
          expensesItems.add(newItemsMap);
        }
        object['expensesItems'] = expensesItems;
      }

      if (characteristicsName == 'expense_article_characteristics'
          && object['expensesArticleItems'] != null) {
        for (var item in object['expensesArticleItems'].values) {
          int index = characteristics.lastIndexWhere((element) => element.id == item['id']);
          if (index != -1) {
            newItemsMap[index]['value'] = item['value'];

            newItemsMap[index]['details'] = item['details'];
          }
        }
        object['expensesArticleItems'] = newItemsMap;
      }

      await _fireStore.collection('objects')
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
}