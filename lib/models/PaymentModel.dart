class RazorpayPaymentModel {
  String paymentId;
  String orderId;
  String signature;
  String status;

  RazorpayPaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.signature,
    required this.status,
  });

  factory RazorpayPaymentModel.fromJson(Map<String, dynamic> json) {
    return RazorpayPaymentModel(
      paymentId: json['paymentId'] ?? '',
      orderId: json['orderId'] ?? '',
      signature: json['signature'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'signature': signature,
      'status': status,
    };
  }
}
