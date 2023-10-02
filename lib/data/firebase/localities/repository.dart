import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trezvii_24_driver/domain/firebase/localities/repository.dart';

class LocalitiesRepositoryImpl extends LocalitiesRepository {
  final _localitiesCollection = 'Localities';
  final _instance = FirebaseFirestore.instance;
  List<String>? _localities;
  @override
  Future<List<String>> getAvailableLocalities() async {
    if(_localities != null) return _localities!;
    final col = await _instance.collection(_localitiesCollection).get();
    _localities = col.docs.map((e) => e.id).toList();
    return _localities!;
  }
}