///  data format:
///        {
///             "name":"home.json",
///             "link":"http://xxxxxx/home.json",
///             "md5":"a1d2f3c4",
///         },
import 'package:json_annotation/json_annotation.dart';
part 'bundleObject.g.dart';

@JsonSerializable()
class BundleObject {
  String name;
  String link;
  String md5;
  BundleObject(this.name, this.link, this.md5);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory BundleObject.fromJson(Map<String, dynamic> json) =>
      _$BundleObjectFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BundleObjectToJson(this);
}
