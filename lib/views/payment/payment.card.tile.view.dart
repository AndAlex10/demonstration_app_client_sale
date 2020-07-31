import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/payment.card.controller.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/enums/module.enum.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/payment/payment.card.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';

class PaymentCardTileView extends StatelessWidget {
  final ModuleEnum module;
  final PaymentCard paymentCard;
  final _controller = new PaymentCardController();
  @override
  PaymentCardTileView(this.paymentCard, this.module);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    var userStore = Provider.of<UserStore>(context);
    return InkWell(
      onTap: () async {
        if (ModuleEnum.CART == module) {
          cartStore.setPayment(_controller.setPaymentOrder(paymentCard));
          Navigator.of(context).pop();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Cartão de Crédito',
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${paymentCard.cardNumber}',
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      paymentCard.image,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    _popup(userStore),
                  ],
                )
              ],
            )),
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(4.0)),
      ),
    );
  }

  Widget _popup(UserStore userStore) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentCardView(paymentCard)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.remove_red_eye),
                    Text("Visualizar")
                  ],
                )),
          ),
          PopupMenuItem(
            value: 2,
            child: FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _controller
                      .remove(userStore, paymentCard)
                      .then((val) async {
                    if (!val.success) {
                      await WidgetsCommons.message(context, val.message, true);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Icon(Icons.delete), Text("Excluir")],
                )),
          ),
        ],
      );
}
