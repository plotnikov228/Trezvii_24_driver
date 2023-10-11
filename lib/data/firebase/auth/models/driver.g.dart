// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      confirmed: json['confirmed'] as bool,
      currentPosition: json['currentPosition'] == null
          ? null
          : AppLatLong.fromJson(
              json['currentPosition'] as Map<String, dynamic>),
      ratings: (json['ratings'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      userId: json['userId'] as String,
      number: json['number'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      blocked: (json['blocked'] as dynamic) ?? false,
      registrationDate: json['registrationDate'] is String ? DateTime.parse(json['registrationDate'] as String) : (json['registrationDate'] as Timestamp).toDate(),
      personalDataOfTheDriver: json['personalDataOfTheDriver'] == null
          ? null
          : PersonalDataOfTheDriver.fromJson(
              json['personalDataOfTheDriver'] as Map<String, dynamic>),
      car: json['car'] == null
          ? null
          : Car.fromJson(json['car'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'userId': instance.userId,
      'number': instance.number,
      'email': instance.email,
      'name': instance.name,
      'blocked': instance.blocked,
      'registrationDate': instance.registrationDate,
      'ratings': instance.ratings,
      'currentPosition': instance.currentPosition,
      'confirmed': instance.confirmed,
      'personalDataOfTheDriver': instance.personalDataOfTheDriver,
      'car': instance.car,
    };
