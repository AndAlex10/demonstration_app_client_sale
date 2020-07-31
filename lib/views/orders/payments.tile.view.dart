import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/payment.delivery.controller.dart';
import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class PaymentsDeliveryTileView extends StatelessWidget {
  final PaymentDelivery data;
  final _controller = new PaymentDeliveryController();
  PaymentsDeliveryTileView(this.data);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return InkWell(
      onTap: () {
        cartStore.setPayment(_controller.setPaymentOrder(this.data));
        Navigator.of(context).pop();
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    data.image,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    data.title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
