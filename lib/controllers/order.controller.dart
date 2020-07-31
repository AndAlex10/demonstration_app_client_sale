import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/enums/status.order.enum.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.interface.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/view_model/order.view.model.dart';

class OrderController {
  IOrderRepository repository;
  IEstablishmentRepository establishmentRepository;
  IPaymentRepository paymentRepository;
  CieloComponent cieloComponent;
  ConnectComponent connect;

  OrderController(){
    repository = new OrderRepository();
    establishmentRepository = new EstablishmentRepository();
    paymentRepository = new PaymentRepository();
    cieloComponent = new CieloComponent();
    connect = new ConnectComponent();
  }

  OrderController.tests(this.repository, this.establishmentRepository, this.paymentRepository, this.cieloComponent, this.connect);

  Future<OrderViewModel> getAllUser(String idUser, int tab) async{
    OrderViewModel orderViewModel = new OrderViewModel();
    orderViewModel.checkConnect = await connect.checkConnect();

    if(orderViewModel.checkConnect) {
      List<OrderData> ordersUserList = await repository.getOrdersUser(idUser);

      for (OrderData orderUser in ordersUserList) {
        bool add = false;
        if (tab == 0 && (orderUser.status != StatusOrder.CONCLUDED.index &&
            orderUser.status != StatusOrder.CANCELED.index)) {
          add = true;
        } else if (tab == 1 &&
            (orderUser.status == StatusOrder.CONCLUDED.index ||
                orderUser.status == StatusOrder.CANCELED.index)) {
          add = true;
        }

        if (add) {
          orderViewModel.list.add(orderUser);
        }
      }
    }

    return orderViewModel;
  }

  Future<ValidateResponse> cancel(UserStore store, OrderData orderData) async {
    ValidateResponse validate = new ValidateResponse();
    store.setLoading(true);
    if(await connect.checkConnect()) {
      orderData = await repository.refreshOrder(orderData.id);
      if (orderData.status != StatusOrder.PENDING.index) {
        if (orderData.status == StatusOrder.CANCELED.index) {
          validate.message =
          "Não é possivel cancelar mais o pedido, pois já foi cancelado.";
        } else {
          validate.message =
          "Não é possivel cancelar mais o pedido, pois já está em andamento.";
        }
      } else {
        if (!orderData.payment.inDelivery) {
          String value = orderData.amount.toString().replaceAll(".", "");
          validate = await cieloComponent.cancelSale(
              orderData.payment.paymentId, value, true);
        } else {
          validate.success = true;
        }

        if (validate.success) {
          orderData.dateUpdate = Timestamp.now();
          orderData.reasonBy = "Cliente";
          DateTime dateUpdate = orderData.dateUpdate.toDate();
          String dateText = DateFormat('dd/MM/yyyy HH:mm a').format(dateUpdate);
          orderData.historic.add(
              StatusOrderText.getTitle(StatusOrder.CANCELED) + " as " +
                  dateText);
          orderData.setHistoricText();
          await repository.cancel(orderData);
        }
      }
    } else {
      validate.failConnect();
    }
    store.setLoading(false);
    return validate;
  }
}