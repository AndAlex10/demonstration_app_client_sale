import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/cart.entities.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class CartTileView extends StatelessWidget {
  final CartProduct cartProduct;

  CartTileView(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    var cartStore = Provider.of<CartStore>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                cartProduct.productData.images.length > 0
                    ? Container(
                        padding: EdgeInsets.all(4.0),
                        width: 80.0,
                        child: Image.network(
                          cartProduct.productData.images[0],
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          cartProduct.quantity.toString() + "x",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              cartProduct.productData.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17.0),
                            ),
                            cartProduct.additionalData.length > 0
                                ? Text(
                                    cartProduct.getListTextAdditionals(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Colors.black38),
                                  )
                                : SizedBox(),
                            cartProduct.productData.options
                                ? Text(
                                    cartProduct.getOptionSelected(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        color: Colors.black38),
                                  )
                                : SizedBox(),
                            Text(
                              "R\$ ${cartProduct.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                )
              ],
            )),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                cartStore.removeItem(cartProduct);
              },
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
