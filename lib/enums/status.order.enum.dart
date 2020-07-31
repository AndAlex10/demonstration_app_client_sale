
enum StatusOrder {
  PENDING,
  IN_PRODUCTION,
  READY_FOR_DELIVERY,
  DELIVERY_ARRIVED_ESTABLISHMENT,
  OUT_FOR_DELIVERY,
  DELIVERY_ARRIVED_CLIENT,
  CONCLUDED,
  CANCELED
}


class StatusOrderText {

  static String getTitle(StatusOrder status){
    switch (status){
      case StatusOrder.PENDING: {
        return "PENDENTE";
      }
      case StatusOrder.IN_PRODUCTION: {
        return "EM PRODUÇÃO";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "PRONTO PARA ENTREGA";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "SAIU PARA ENTREGA";
      }
      case StatusOrder.CONCLUDED: {
        return "CONCLUÍDO";
      }
      case StatusOrder.CANCELED: {
        return "CANCELADO";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

  static String getNextStatus(StatusOrder status){
    switch (status){
      case StatusOrder.IN_PRODUCTION: {
        return "PRONTO PARA ENTREGA";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "SAIU PARA ENTREGA";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "CONCLUIR";
      }
      default: {
        return "NOT FOUND";
      }

    }
  }

}