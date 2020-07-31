import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';

class EstablishmentTileView extends StatelessWidget {
  final EstablishmentData data;

  EstablishmentTileView(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[ Card(
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(1.0),
                    width: 80.0,
                    child: Image.network(
                      data.imgUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text(
                          " ${data.name} ",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                        Text("("),
                        Text(
                          "${data.open ? "Aberto" : "Fechado"}",
                          style: TextStyle(

                              color: data.open ? Colors.green : Colors.redAccent),
                        ),
                        Text(")")
                      ],),

                      data.rating == 0 ?
                      Text(
                        " Novo ",
                        style: TextStyle(fontSize: 12.0, color: Colors.amber),
                      )
                          : Row(children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 11.0,
                          color: Colors.amber,
                        ),
                        Text(
                          " ${data.rating} ",
                          style: TextStyle(fontSize: 12.0, color: Colors.amber),
                        ),
                        Text(
                          " ${data.type} ",
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black38),
                        ),
                      ]),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 14.0,
                          ),
                          Text(
                            " ${data.neighborhood} ",
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black38),
                          ),
                        ],
                      ),
                      data.feeDelivery != null ? Row(children: <Widget>[
                        data.fee ? Text(
                          " Taxa",
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.black38),
                        ) :SizedBox(),
                        data.fee ? Text(
                          " grátis",
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.green),
                        ) : SizedBox(),
                        Text(
                          " ${data.feeDelivery} ",
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.black38),
                        )
                      ],) : SizedBox(),
                    ],
                  ),
                ],
              )
          ),
      shape: RoundedRectangleBorder(
          //borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.black12)),
        ), SizedBox(height: 5.0,)],);
  }
}
