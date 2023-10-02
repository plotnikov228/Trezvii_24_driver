import 'package:trezvii_24_driver/domain/payment/models/payment_methods.dart';

class LocalOutputRequest {
  final String orderId;
  final PaymentMethod paymentMethod;

  LocalOutputRequest({required this.orderId, required this.paymentMethod});
  factory LocalOutputRequest.fromJson(Map<String, dynamic> json) => LocalOutputRequest(orderId: json['orderId'], paymentMethod: PaymentMethod.fromString(json['paymentMethod']));
  Map<String, dynamic> toJson () => {
    'orderId': orderId,
    'paymentMethod': paymentMethod.toString()
  };

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return Object is LocalOutputRequest && (other as LocalOutputRequest).orderId == orderId;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;



}