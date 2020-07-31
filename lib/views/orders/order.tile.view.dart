import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/enums/status.order.enum.dart';
import 'package:venda_mais_client_buy/views/orders/order.detail.view.dart';
import 'package:venda_mais_client_buy/views/orders/rating.order.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:flutter_rating/flutter_rating.dart';

class OrderTileView extends StatefulWidget {
  final OrderData order;

  OrderTileView(this.order);

  @override
  _OrderTileViewState createState() => _OrderTileViewState(this.order);
}

class _OrderTileViewState extends State<OrderTileView> {
  final OrderData order;
  DateTime date;
  StatusOrder statusOrder;

  _OrderTileViewState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetailView(order)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(1.0),
                            width: 45.0,
                            child: Image.network(
                              order.imgUrlEstableshiment,
                              width: 45,
                              height: 45,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "${order.nameEstablishment}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16.0),
                          ),
                        ]),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Pedido ${order.orderCode} - ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: WidgetsCommons.buttonColor(),
                            size: 16.0,
                          ),
                          Text(
                            " ${DateFormat('dd/MM/yyyy HH:mm a').format(date)}",
                            style: TextStyle(
                                color: WidgetsCommons.buttonColor(),
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0),
                          ),
                        ]),
                    Divider(),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      _buildProductsText(order.items),
                      style: TextStyle(color: Colors.black38),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 5.0,
                    ),
                    order.status != StatusOrder.CANCELED.index
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildCircle("Aprovado", order.status,
                                    StatusOrder.PENDING.index),
                                Container(
                                  height: 1.0,
                                  width: 15.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("Preparação", order.status,
                                    StatusOrder.IN_PRODUCTION.index),
                                Container(
                                  height: 1.0,
                                  width: 15.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("Pronto", order.status,
                                    StatusOrder.READY_FOR_DELIVERY.index),
                                Container(
                                  height: 1.0,
                                  width: 15.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("Enviado", order.status,
                                    StatusOrder.OUT_FOR_DELIVERY.index),
                                Container(
                                  height: 1.0,
                                  width: 15.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("Entregue", order.status,
                                    StatusOrder.CONCLUDED.index),
                              ],
                            ),
                          )
                        : Text(
                            'Cancelado',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.red),
                          ),

                    order.status != StatusOrder.CANCELED.index ? SizedBox() :
                    Text(
                      "Motivo: " + order.reason,
                      style: TextStyle(
                          fontWeight: FontWeight.w300
                          , fontSize: 14.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              _ratingOrder()
            ],
          )),
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.black12, width: 2.0)),
    );
  }

  Widget _ratingOrder(){
    if (order.status == StatusOrder.CONCLUDED.index || order.status == StatusOrder.CANCELED.index) {
      return Column(
        children: <Widget>[
          SizedBox(height: 3.0,),
          Divider(),
          SizedBox(height: 3.0,),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RatingOrderView(order)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Avalie seu Pedido: ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  StarRating(
                    size: 20.0,
                    rating: this.order.rating == null ? 0.0 : this.order.rating,
                    color: Colors.orange,
                    borderColor: Colors.grey,
                    starCount: 5,
                    onRatingChanged: null,
                  ),
                ],
              ))
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildCircle(String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = _iconStatus(thisStatus);
    } else if (status == thisStatus &&
        thisStatus != StatusOrder.CONCLUDED.index) {
      backColor = WidgetsCommons.buttonColor();
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _iconStatus(thisStatus),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = WidgetsCommons.buttonColor();
      child = _iconStatus(thisStatus);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 13.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12.0),
        )
      ],
    );
  }

  String _buildProductsText(List<Items> itemsList) {
    String text = '';
    int i = 1;
    text += " ${itemsList[0].quantity}x ${itemsList[0].title}";
    if (itemsList.length > 1)
      text +=
          '\n +${itemsList.length - 1} ${itemsList.length > 2 ? "itens" : "item"}';
    return text;
  }

  Widget _iconStatus(int thisStatus) {
    return Icon(
      thisStatus == StatusOrder.PENDING.index
          ? Icons.add_shopping_cart
          : thisStatus == StatusOrder.IN_PRODUCTION.index
              ? Icons.local_dining
              : thisStatus == StatusOrder.READY_FOR_DELIVERY.index
                  ? Icons.check
                  : thisStatus == StatusOrder.OUT_FOR_DELIVERY.index
                      ? Icons.motorcycle
                      : thisStatus == StatusOrder.CONCLUDED.index
                          ? Icons.home
                          : Icons.cancel,
      color: Colors.white,
      size: 14.0,
    );
  }
}
