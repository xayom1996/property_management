import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addObject() async {
    DocumentSnapshot objectCharacteristics = await _fireStore.collection('characteristics')
        .doc('object_characteristics')
        .get();
    var characteristics = objectCharacteristics.data() as Map<String, dynamic>;
    List<Characteristics> objectItems = List<Characteristics>.from(
        characteristics.values.map((item) => Characteristics.fromJson(item)));
    objectItems.sort((a, b) => a.id.compareTo(b.id));
    for (var i = 0; i < objectItemsFilled.length; i++){
      objectItems[i].value = objectItemsFilled[i]['value'];
    }
    Map<String, dynamic> objectMap = {for (var item in objectItems) item.title : item.toJson()};
    await _fireStore.collection('objects')
        .add({
      'objectItems': objectMap,
      // 'tenantItems': 'tenantItems',
      'ownerId': 'ownerId',
      'createdDate': 'createdDate',
    })
    .then((value) => print("Object Added"))
    .catchError((error) => print("Failed to add: $error"));
  }

  Future<List<Place>> getObjects(User user) async {
    QuerySnapshot querySnapshot;
    if (user.role == 'admin') {
      querySnapshot = await _fireStore.collection('objects')
          .get();
    }else {
      querySnapshot = await _fireStore.collection('objects').where('ownerId', isEqualTo: user.id).get();
    }

    List<Place> places = querySnapshot.docs.map((doc) => Place.fromJson(doc.data() as Map<String, dynamic>)).toList();
    return places;
  }
}