import 'package:trezvii_24_driver/domain/db/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


import '../../firebase/auth/models/user_model.dart';

class InitDB {
  final DBRepository repository;

  InitDB(this.repository);

  Future<Database> call () {
    return repository.initDB();
  }
}