import 'package:cloud_firestore/cloud_firestore.dart';
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
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems']['Процент от товарооборота']['value'])
            && isNotEmpty(object['expensesItems'][i]['Фактический товарооборот']['value'])) {
          try {
            object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] =
                double.parse(
                    object['expensesItems'][i]['Фактический товарооборот']['value']) *
                    (100 - double.parse(
                        object['tenantItems']['Процент от товарооборота']['value'])) /
                    100;
            object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] =
                double.parse(object['expensesItems'][i]['Сумма Аренды от товарооборота']['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] = '0';
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

    String startStr = expensesArticleMap['Начало даты расчета']['value'] ?? '';
    String finishStr = expensesArticleMap['Конец даты расчета']['value'] ?? '';
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
    if (object['tenantItems'] != null && isNotEmpty(object['tenantItems']['Процент от товарооборота']['value'])
        && isNotEmpty(expensesMap['Фактический товарооборот']['value'])) {
      try {
        expensesMap['Сумма Аренды от товарооборота']['value'] =
            double.parse(expensesMap['Фактический товарооборот']['value']) *
                (100 - double.parse(object['tenantItems']['Процент от товарооборота']['value'])) / 100;
        expensesMap['Сумма Аренды от товарооборота']['value'] = double.parse(expensesMap['Сумма Аренды от товарооборота']['value'].toStringAsFixed(2)).toString();
      } catch(e) {
        print(e);
      }
    } else {
      expensesMap['Сумма Аренды от товарооборота']['value'] = '0';
    }

    List expensesDates = [for (var i = 0; i < expensesItems.length; i++) if (i != monthIndex) expensesItems[i]['Месяц, Год']['value']];

    if (expensesDates.contains(expensesMap['Месяц, Год']['value'])){
      throw Exception('Эксплуатация за этот месяц уже существует');
    }

    if (monthIndex != null) {
      expensesItems[monthIndex] = expensesMap;
    } else {
      expensesItems.add(expensesMap);

      DateTime newDate = DateTime.now();
      DateTime currentDate = DateFormat('MM.yyyy').parse(expensesMap['Месяц, Год']['value']);

      while (DateFormat('MM.yyyy').format(currentDate) != DateFormat('MM.yyyy').format(newDate)) {
        if (!expensesDates.contains(DateFormat('MM.yyyy').format(currentDate))
            && DateFormat('MM.yyyy').format(currentDate) != expensesMap['Месяц, Год']['value']){
          Map<String, dynamic> defaultExpensesMap = {for (var item in defaultExpenseItems!) item.title : item.toJson()};
          defaultExpensesMap['Месяц, Год']['value'] = DateFormat('MM.yyyy').format(currentDate);
          expensesItems.add(defaultExpensesMap);
        }
        if (newDate.isBefore(currentDate)) {
          currentDate = DateTime(currentDate.year, currentDate.month - 1);
        } else {
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }
      }

      if (!expensesDates.contains(DateFormat('MM.yyyy').format(currentDate))
          && DateFormat('MM.yyyy').format(currentDate) != expensesMap['Месяц, Год']['value']){
        Map<String, dynamic> defaultExpensesMap = {for (var item in defaultExpenseItems!) item.title : item.toJson()};
        defaultExpensesMap['Месяц, Год']['value'] = DateFormat('MM.yyyy').format(currentDate);
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
    Map<String, dynamic> planMap = {for (var item in planItems) item.title : item.toJson()};

    String startStr = planMap['Начало даты расчета']['value'] ?? '';
    String finishStr = planMap['Конец даты расчета']['value'] ?? '';
    if (startStr.isNotEmpty && finishStr.isNotEmpty) {
      DateTime start = DateFormat('dd.MM.yyyy').parse(startStr);
      DateTime finish = DateFormat('dd.MM.yyyy').parse(finishStr);
      if (start.isAtSameMomentAs(finish) || start.isAfter(finish)) {
        throw Exception('Дата конца расчета должна быть больше даты начала');
      }
    }

    String str = planMap['Потери от недогрузки (смена арендатора)']['value'] ?? '';
    if (str.isEmpty) {
      planMap['Потери от недогрузки (смена арендатора)']['value'] = '0';
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
    Map<String, dynamic> objectMap = {for (var item in filledItems) item.title : item.toJson()}; // 2016-01-25
    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'objectItems': objectMap,
        })
        .then((value) => print("Object updated"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> editTenant({required List<Characteristics> filledItems, required String docId}) async {
    Map<String, dynamic> tenantMap = {for (var item in filledItems) item.title : item.toJson()}; // 2016-01-25

    DocumentSnapshot snapshot = await _fireStore.collection('objects').doc(docId).get();

    var object = snapshot.data() as Map<String, dynamic>;

    object['tenantItems'] = tenantMap;

    if (object['expensesItems'] != null) {
      for (var i = 0; i < object['expensesItems'].length; i++){
        if (object['tenantItems'] != null && isNotEmpty(object['tenantItems']['Процент от товарооборота']['value'])
            && isNotEmpty(object['expensesItems'][i]['Фактический товарооборот']['value'])) {
          try {
            object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] =
                double.parse(
                    object['expensesItems'][i]['Фактический товарооборот']['value']) *
                    (100 - double.parse(
                        object['tenantItems']['Процент от товарооборота']['value'])) /
                    100;
            object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] =
                double.parse(object['expensesItems'][i]['Сумма Аренды от товарооборота']['value']
                    .toStringAsFixed(2)).toString();
          } catch (e) {
            print(e);
          }
        } else {
          object['expensesItems'][i]['Сумма Аренды от товарооборота']['value'] = '0';
        }
      }
    }
    await _fireStore.collection('objects')
        .doc(docId)
        .update(object)
        .then((value) => print("Object Added"))
        .catchError((error) => throw Exception('Error adding'));
  }

  Future<void> updateColorObject({required String docId, required String value}) async {
    await _fireStore.collection('objects')
        .doc(docId)
        .update({
          'tenantItems.Отмеченный клиент.value': value,
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
      querySnapshot = await _fireStore.collection('objects').where('objectItems.Собственник.value', whereIn: owners).get();
    }
    List<Place> places = querySnapshot.docs.map((doc) {
      var place = doc.data() as Map<String, dynamic>;
      place['id'] = doc.id;

      double sumTaxes = 0;
      double sumCurrentRent = 0;
      for (var item in place['expensesItems'] ?? []) {
        if (item['Месяц, Год']['value'] == DateFormat('MM.yyyy').format(DateTime.now())) {
          if (place['tenantItems'] != null) {
            place['tenantItems']['Текущая аренда']['value'] = item['Текущая арендная плата']['value'];
          }
          if (place['objectItems'] != null) {
            if (place['objectItems']['Арендная плата']['value'] == null
                || place['objectItems']['Арендная плата']['value'] == '') {
              place['objectItems']['Арендная плата']['value'] =
              item['Текущая арендная плата']['value'];
            }
          }
        }

        /// Сумма налогов и арендной платы за последний год
        DateTime date = DateFormat('MM.yyyy').parse(item['Месяц, Год']['value']);
        DateTime now = DateTime.now();
        if (date.isAfter(DateTime(now.year - 1, now.month, now.day))
            && date.isBefore(now)){
          if (item['Налоги']['value'] != null && item['Налоги']['value'] != '') {
            sumTaxes = sumTaxes + double.parse(item['Налоги']['value']);
          }
          if (item['Текущая арендная плата']['value'] != null
              && item['Текущая арендная плата']['value'] != '') {
            sumCurrentRent = sumCurrentRent +
                double.parse(item['Текущая арендная плата']['value']);
          }
        }
      }

      place['objectItems']['Рыночная стоимость помещения']['value'] = null;
      if (place['objectItems']['Арендная плата']['value'] != null
          && place['objectItems']['Арендная плата']['value'] != '') {
        if (place['objectItems']['Коэффициент капитализации']['value'] != null
            && place['objectItems']['Коэффициент капитализации']['value'] != '') {
          place['objectItems']['Рыночная стоимость помещения']['value'] =
              removeTrailingZeros((double.parse(place['objectItems']['Арендная плата']['value']) /
                  (double.parse(
                      place['objectItems']['Коэффициент капитализации']['value']) / 100)).toStringAsFixed(2));
        }
      }

      if (sumCurrentRent != 0 && sumTaxes != 0) {
        if (place['objectItems'] != null) {
          place['objectItems']['Фактическая Налоговая нагрузка']['value'] = double.parse((sumTaxes / sumCurrentRent).toStringAsFixed(2)).toString();
        }
      }
      return Place.fromJson(place);
    }).toList();
    return places;
  }

  Future<List<String>> getOwners(User user) async {
    QuerySnapshot querySnapshot;
    if (user.role == 'admin') {
      querySnapshot = await _fireStore.collection('owners').get();
    }else if (user.role == 'manager') {
      querySnapshot = await _fireStore.collection('owners').where('managers', arrayContains: user.email).get();
    } else {
      querySnapshot = await _fireStore.collection('owners').where('holders', arrayContains: user.email).get();
    }

    List<String> owners = querySnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['name'].toString()).toList();
    print(owners);
    return owners;
  }
}