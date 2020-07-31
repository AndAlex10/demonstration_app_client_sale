
class OrderRequest {
  String orderId;
  String orderCode;
  String idEstablishment;
  String action;

  OrderRequest.from(this.orderId, this.orderCode, this.idEstablishment, this.action);

  Map<String, dynamic> toMap() {
    return {
      "orderId": this.orderId,
      "orderCode": this.orderCode,
      "idEstablishment": this.idEstablishment,
      "action": this.action
    };
  }
}