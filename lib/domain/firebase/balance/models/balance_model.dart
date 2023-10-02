import 'package:json_annotation/json_annotation.dart';
part 'balance_model.g.dart';
@JsonSerializable()
class BalanceModel {
  final double cost;

  BalanceModel({required this.cost});

  factory BalanceModel.fromJson(Map<String, dynamic> json) => _$BalanceModelFromJson(json);
  Map<String, dynamic> toJson () => _$BalanceModelToJson(this);
}