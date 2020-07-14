/// data format
/// {
///     "appId":"xxxxxx-xxxxxx-xxxxxx",
///     "currentVersion:"10001",
///     "build":"100",
///     "bundles":[
///         {
///             "name":"home.json",
///             "link":"http://xxxxxx/home.json",
///             "md5":"a1d2f3c4",
///         },
///         {
///             "name":"detail.json",
///             "link":"http://xxxxxx/detail.json",
///             "md5":"a1d2f3c4",
///         },
///     ],
///     "indexKey":"home"
///  }
import 'package:pocket4d/bean/bundleObject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundleJson.g.dart';

@JsonSerializable()
class BundleJson {
  String appId;
  int currentVersion;
  String build;
  List<BundleObject> bundles;
  BundleJson(this.appId, this.currentVersion, this.build, this.bundles);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory BundleJson.fromJson(Map<String, dynamic> json) =>
      _$BundleJsonFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BundleJsonToJson(this);
}
