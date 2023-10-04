// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      name: json['name'] as String?,
      comment: json['comment'] as String?,
      addressName: json['addressName'] as String,
      entrance: json['entrance'] as String?,
      locality: json['locality'],
      province: json['province'],
      appLatLong:
          AppLatLong.fromJson(json['appLatLong'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'addressName': instance.addressName,
      'appLatLong': instance.appLatLong.toJson(),
      'locality': instance.locality,
      'name': instance.name,
      'entrance': instance.entrance,
      'comment': instance.comment,
      'province': instance.province

    };
