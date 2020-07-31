import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:venda_mais_client_buy/enums/method.payment.enum.dart';
import 'package:venda_mais_client_buy/views/orders/payments.tab.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class PaymentCartView extends StatelessWidget {
  final _changeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool delivery = true;
    var cartStore = Provider.of<CartStore>(context);
    if (cartStore.payment != null) {
      delivery = cartStore.payment.inDelivery;
    }
    return Card(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Forma de pagamento',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18.0),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    cartStore.payment == null
                        ? _viewPayments(
                            context, "Escolher", cartStore.establishment.id)
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cartStore.payment == null
                              ? ''
                              : cartStore.payment.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                              fontSize: 16.0),
                          textAlign: TextAlign.start,
                        ),
                        cartStore.payment != null
                            ? Text(
                                delivery
                                    ? "Pagamento na entrega"
                                    : cartStore.payment.cardNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0),
                                textAlign: TextAlign.start,
                              )
                            : SizedBox(),
                        cartStore.payment != null
                            ? _getChange(context, cartStore)
                            : SizedBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        cartStore.payment != null
                            ? Image.asset(
                                cartStore.payment.image,
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              )
                            : SizedBox(),
                        SizedBox(
                          width: 10.0,
                        ),
                        cartStore.payment != null
                            ? _viewPayments(
                                context, "Trocar", cartStore.establishment.id)
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }

  _displayDialog(BuildContext context, TextEditingController controller) async {
    return Alert(
      context: context,
      // type: AlertType.info,
      title: 'Troco para quanto?',
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(hintText: "Informe aqui o valor"),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Confirmar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  Widget _getChange(BuildContext context, CartStore cartStore) {
    return cartStore.payment.method.toUpperCase() == MethodPayment.MONEY
        ? Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                child: cartStore.change == 0.00
                    ? Text(
                        'Precisa de troco?',
                        style: TextStyle(
                            color: WidgetsCommons.buttonColor(),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Troco para: R\$${cartStore.change.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: WidgetsCommons.buttonColor(),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                onTap: () async {
                  if (cartStore.change > 0) {
                    _changeController.text =
                        cartStore.change.toStringAsFixed(2);
                  }
                  await _displayDialog(context, _changeController);
                  if (_changeController.text != "") {
                    cartStore.setChange(double.parse(_changeController.text));
                  }
                },
              )
            ],
          )
        : SizedBox();
  }

  Widget _viewPayments(
      BuildContext context, String title, String idEstablishment) {
    return GestureDetector(
      child: Text(
        title,
        style: TextStyle(
            color: WidgetsCommons.buttonColor(),
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentsView(idEstablishment)));
      },
    );
  }
}
