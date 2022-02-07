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

  // Future<void> addTenantCharacteristics() async {
  //   Map<String, dynamic> tenantCharacteristics = {};
  //   for (var i = 0; i < tenantItems.length; i++) {
  //     tenantCharacteristics[tenantItems[i]['title']] = {
  //       'id': i,
  //       'title': tenantItems[i]['title'],
  //       'placeholder': tenantItems[i]['placeholder'],
  //       'type': tenantItems[i]['type'],
  //       'unit': tenantItems[i]['unit'],
  //     };
  //   }
  //   await _fireStore.collection('characteristics')
  //       .doc('tenant_characteristics')
  //       .set(tenantCharacteristics)
  //       .then((value) => print("tenant_characteristics Added"))
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

  Future<void> editObject({required List<Characteristics> filledItems, required String docId}) async {
    Map<String, dynamic> objectMap = {for (var item in filledItems) item.title : item.toJson()}; // 2016-01-25
    await _fireStore.collection('objects')
        .doc(docId)
        .set({
          'objectItems': objectMap,
          'createdDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
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