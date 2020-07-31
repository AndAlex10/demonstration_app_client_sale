import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/cart.controller.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CartPriceView extends StatelessWidget {
  final VoidCallback buy;
  final _controller = new CartController();

  CartPriceView(this.buy);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    var userStore = Provider.of<UserStore>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) {
            double price = _controller.getProductsPrice(cartStore.uniqueProducts);
            double discount = _controller.getDiscount(cartStore.coupon);
            double shipPrice = _controller.getShipPrice(cartStore);
            double total = _controller.getAmount(cartStore);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do Pedido',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('SubTotal'),
                    Text('R\$${price.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Desconto'),
                    Text('R\$${discount.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Taxa de entrega'),
                    Text(_controller.getShipPriceText(cartStore.shipPrice),
                      style: TextStyle(
                          color: cartStore.shipPrice == 0.00
                              ? Colors.green
                              : cartStore.shipPrice == null
                                  ? Colors.red
                                  : Colors.black),
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'R\$${total.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 5.0,
                ),
                Divider(),
                SizedBox(
                  height: 6.0,
                ),
                SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        cartStore.establishment.open
                            ? 'Finalizar Pedido'
                            : 'Fechado',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: WidgetsCommons.buttonColor(),
                      onPressed:
                          _controller.validateFinishOrder(cartStore, userStore)
                              ? () {
                                  buy();
                                }
                              : null,
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
