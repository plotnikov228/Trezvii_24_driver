
import 'package:json_annotation/json_annotation.dart';
part 'card.g.dart';

@JsonSerializable()
class UserCard {
  final String number;

  UserCard(
      {required this.number,});

  factory UserCard.fromJson(Map<String, dynamic> json) => _$UserCardFromJson(json);
  Map<String, dynamic> toJson () => _$UserCardToJson(this);
}
