// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundleItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItem _$BundleItemFromJson(Map<String, dynamic> json) {
  return BundleItem(
    json['AppId'] as String,
    json['Name'] as String,
  );
}

Map<String, dynamic> _$BundleItemToJson(BundleItem instance) =>
    <String, dynamic>{
      'AppId': instance.appId,
      'Name': instance.name,
    };
