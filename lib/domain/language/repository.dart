import 'package:trezvii_24_driver/domain/language/models/language.dart';

abstract class LanguageRepository {
  Future<Language> getLanguage();
  Future setLanguage (Language language);
}