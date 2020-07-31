import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/controllers/cart.controller.dart';
import 'package:venda_mais_client_buy/controllers/product.controller.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.view.dart';
import 'package:venda_mais_client_buy/views/products/additional.view.dart';
import 'package:venda_mais_client_buy/views/products/options.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class ProductView extends StatefulWidget {
  final ProductData data;
  final String idEstablishment;
  final String category;

  ProductView(this.data, this.idEstablishment, this.category);

  @override
  _ProductViewState createState() =>
      _ProductViewState(this.data, this.idEstablishment, this.category);
}

class _ProductViewState extends State<ProductView> {
  final ProductData data;
  final String idEstablishment;
  final String category;
  final _cartController = new CartController();
  final _productController = new ProductController();
  final _obsController = TextEditingController();

  _ProductViewState(this.data, this.idEstablishment, this.category);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    var userStore = Provider.of<UserStore>(context);
    cartStore.setProduct(this.data);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Informações do Item'),
          centerTitle: true,
        ),
        body: Observer(builder: (_) { return Card(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          cartStore.productCurrent.image != null
                              ? Container(
                                  padding:
                                      EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 10.0),
                                  height: 200.0,
                                  child: Image.network(
                                    cartStore.productCurrent.image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(),
                          Text(
                            cartStore.productCurrent.title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                fontSize: 21.0),
                          ),
                          cartStore.productCurrent.description != null
                              ? Text(
                                  cartStore.productCurrent.description,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 16.0),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            cartStore.productCurrent.options
                                ? " A partir de R\$ ${cartStore.productCurrent.price.toStringAsFixed(2)}"
                                : "R\$ ${cartStore.productCurrent.price.toStringAsFixed(2)} ",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.green),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),

                          AdditionalView(),
                          OptionsView(),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Icon(Icons.textsms),
                              Text(
                                " Alguma Observação? ",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                          Container(
                              width: 50.00,
                              height: 100.00,
                              child: TextFormField(
                                controller: _obsController,
                                decoration: InputDecoration(
                                    labelText: 'Digite a Observação...',
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black)),
                                enabled: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                              )),
                        ],
                      ))),
              Container(
                  height: 110.0,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Card(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: WidgetsCommons.buttonColor(),
                                      size: 35.0,
                                    ),
                                    color: WidgetsCommons.buttonColor(),
                                    onPressed: cartStore.quantity > 1
                                        ? () {
                                            cartStore.setItemSub();
                                            cartStore.setAmountProduct(_productController.recalculateValue(cartStore.productCurrent));
                                          }
                                        : null,
                                  ),
                                Text(
                                    cartStore.quantity.toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: WidgetsCommons.buttonColor(),
                                    size: 35.0,
                                  ),
                                  color: WidgetsCommons.buttonColor(),
                                  onPressed: () {
                                    cartStore.setItemAdd();
                                    cartStore.setAmountProduct(_productController.recalculateValue(cartStore.productCurrent));
                                  },
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            SizedBox(
                              height: 50.0,
                              child: RaisedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Adicionar",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                          "R\$${cartStore.amountProduct.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500))
                                  ],
                                ),
                                textColor: Colors.white,
                                color: WidgetsCommons.buttonColor(),
                                onPressed: _productController.enableProduct(
                                        cartStore.productCurrent)
                                    ? () async {
                                        if (userStore.isLoggedIn()) {
                                          await _cartController
                                              .add(
                                                  cartStore,
                                                  idEstablishment,
                                                  category,
                                                  cartStore
                                                      .productCurrent,
                                                  _obsController.text)
                                              .then((val) {
                                            if (val.success) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CartView()));
                                            } else {
                                              WidgetsCommons.message(
                                                  context, val.message, true);
                                            }
                                          });
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(false)));
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                          ]),
                    ],
                  )),
            ])));}));
  }
}
