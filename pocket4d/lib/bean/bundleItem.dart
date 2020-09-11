import 'package:json_annotation/json_annotation.dart';

part 'bundleItem.g.dart';

@JsonSerializable()
class BundleItem extends Object {
  @JsonKey(name: 'AppId')
  String appId;

  @JsonKey(name: 'Name')
  String name;

  BundleItem(
    this.appId,
    this.name,
  );

  factory BundleItem.fromJson(Map<String, dynamic> srcJson) => _$BundleItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BundleItemToJson(this);
}
