import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/data/language/repository.dart';
import 'package:trezvii_24_driver/domain/language/models/language.dart';

class AllLocale {

  static final all = LanguageRepositoryImpl().languages.map((e) => Locale(e.langCode, e.countryCode));
}