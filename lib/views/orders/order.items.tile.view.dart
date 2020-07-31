import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';

class ItemOrderTileView extends StatelessWidget {
  final Items data;

  ItemOrderTileView(this.data);

  @override
  Widget build(BuildContext context) {
    return  Card(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "#${data.title}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "  ${data.title}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "  R\$ ${data.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ]),
                data.additionalList.length  > 0 ?
                Text(
                  "  Adicionais:",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ) : SizedBox(),

                ListView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  itemCount: data.additionalList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return _getAdditional(data.additionalList[index]);
                  },
                ),
                Divider(),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        " Quantidade: ${data.quantity}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Total item: R\$ ${data.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ]),

                _obs(),

              ],
            ),
          ),
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.black38, width: 2.0)),
        );
  }


  Widget _getAdditional(Additional additional) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "      ${additional.title}",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14.0),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "      R\$ ${additional.price.toStringAsFixed(2)}",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14.0),
          ),
        ]);
        }

  Widget _obs(){
    return data.obs != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Text('Observação: ' + data.obs, style: TextStyle(fontStyle: FontStyle.italic),),
        SizedBox(
          height: 12.0,
        ),
      ],
    ) : SizedBox(
      height: 0.0,
    );
  }
}
