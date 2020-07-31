import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/views/products/product.view.dart';

class ProductTileView extends StatelessWidget {
  final ProductData data;

  final String idEstablishment;

  final String category;

  ProductTileView(this.data, this.idEstablishment, this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProductView(data, idEstablishment, this.category)));
        },
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${data.title} ",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'RobotoMono',
                            color: Colors.black),
                      ),
                      data.description != null
                          ? Text(
                              "${data.description} ",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        data.options
                            ? " A partir de R\$ ${data.price.toStringAsFixed(2)}"
                            : "R\$ ${data.price.toStringAsFixed(2)} ",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ],
                  )),
                  data.image != null
                      ? Container(
                          width: 95.0,
                          padding: EdgeInsets.all(1.0),
                          child: Image.network(
                            data.image,
                            width: 80,
                            height: 95,
                            fit: BoxFit.contain,
                          ),
                        )
                      : SizedBox(),
                ]),

                Divider()
              ],
            )
        ));
  }
}
