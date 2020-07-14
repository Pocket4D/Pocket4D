// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundleObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleObject _$BundleObjectFromJson(Map<String, dynamic> json) {
  return BundleObject(
    json['name'] as String,
    json['link'] as String,
    json['md5'] as String,
  );
}

Map<String, dynamic> _$BundleObjectToJson(BundleObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
      'md5': instance.md5,
    };
