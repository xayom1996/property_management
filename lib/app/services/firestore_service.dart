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

  Future<List<Characteristics>> getObjectCharacteristics() async {
    DocumentSnapshot objectCharacteristics = await _fireStore.collection('characteristics')
        .doc('object_characteristics')
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

  Future<void> deleteObject() async {
    await _fireStore.collection('objects')
        .doc('ABC123')
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

    List<Place> places = querySnapshot.docs.map((doc) => Place.fromJson(doc.data() as Map<String, dynamic>)).toList();
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