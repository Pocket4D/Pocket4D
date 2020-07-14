// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundleJson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleJson _$BundleJsonFromJson(Map<String, dynamic> json) {
  return BundleJson(
    json['appId'] as String,
    json['currentVersion'] as int,
    json['build'] as String,
    (json['bundles'] as List)
        ?.map((e) =>
            e == null ? null : BundleObject.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BundleJsonToJson(BundleJson instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'currentVersion': instance.currentVersion,
      'build': instance.build,
      'bundles': instance.bundles,
    };
