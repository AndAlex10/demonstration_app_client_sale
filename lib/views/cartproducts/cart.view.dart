import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/cart.controller.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/response/order.response.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/home.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/user/user.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.tile.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.address.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.payment.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.price.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.disccount.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = new CartController();

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    var userStore = Provider.of<UserStore>(context);
    return FutureBuilder(
        future: _controller.calculateShipPrice(
            cartStore, userStore.user),
        builder: (context, snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Meu Carrinho'),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  alignment: Alignment.center,
                  child:Text(
                        '${cartStore.uniqueProducts.length ?? 0} ${cartStore.uniqueProducts.length == 1 ? 'ITEM' : 'ITENS'}',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      )
                  ),
          ]
                ),
            body: Observer(builder: (_) {
              if (userStore.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (cartStore.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!userStore.isLoggedIn()) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 80.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Faça o Login para adicionar produtos!',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      RaisedButton(
                        child: Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: WidgetsCommons.buttonColor(),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginView(false)));
                        },
                      )
                    ],
                  ),
                );
              } else if (cartStore.uniqueProducts == null ||
                  cartStore.uniqueProducts.length == 0) {
                return Center(
                  child: Text(
                    'Nenhum produto no carrinho!',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    AddressCartView(),
                    Card(
                        child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  cartStore.establishment == null
                                      ? ""
                                      : cartStore.establishment.name,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Divider(),
                                Column(
                                  children: cartStore.uniqueProducts.map((product) {
                                    return CartTileView(product);
                                  }).toList(),
                                ),
                              ],
                            ))),
                    Card(
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Adicionar mais itens",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: WidgetsCommons.buttonColor()),
                            ))),
                    PaymentCartView(),
                    DiscountCardView(),
                    CartPriceView(() async {
                      userStore.user.phone == ""
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserView(true)))
                          : await _finish(context, cartStore, userStore);
                    }),
                  ],
                );
              }
            }),
          );
        });
  }

  _finish(BuildContext context, CartStore cartStore, UserStore userStore) async {
    await _controller
        .finishOrder(cartStore, userStore)
        .then((response) async {
      OrderResponse orderResponse = response;
      if (orderResponse.success) {
        WidgetsCommons.onGeneric(
            _scaffoldKey, "Pedido Realizado!", WidgetsCommons.buttonColor());

        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeView()));
      } else {
        WidgetsCommons.onFail(_scaffoldKey, orderResponse.message);
        await Future.delayed(Duration(seconds: 2));
      }
    });
  }
}
