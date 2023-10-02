import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trezvii_24_driver/domain/firebase/firestore/repository.dart';

class GetCollectionData {
  final FirebaseFirestoreRepository repository;

  GetCollectionData(this.repository);

  Future<List<Map<String ,dynamic>>> call (String collection)async {
    return repository.getCollectionsData(collection);
  }

}