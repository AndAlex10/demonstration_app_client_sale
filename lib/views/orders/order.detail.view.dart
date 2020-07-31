import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/enums/status.order.enum.dart';
import 'package:venda_mais_client_buy/views/orders/order.items.tile.view.dart';
import 'package:venda_mais_client_buy/views/orders/order.reason.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class OrderDetailView extends StatefulWidget {
  final OrderData order;

  OrderDetailView(this.order);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState(this.order);
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderData order;

  DateTime date;
  StatusOrder statusOrder;

  _OrderDetailViewState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido"),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[_infosOrder(), _getCancelOrder()])),
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black12, width: 2.0)),
      ),
    );
  }

  Widget _getCancelOrder() {
    statusOrder = StatusOrder.values[order.status];
    if (statusOrder == StatusOrder.PENDING) {
      return _cancelOrder();
    } else {
      return SizedBox(
        height: 2.0,
      );
    }
  }

  Widget _cancelOrder() {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 44.0,
          child: RaisedButton(
            child: Text(
              "Cancelar Pedido",
              style: TextStyle(fontSize: 18.0),
            ),
            textColor: Colors.white,
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => OrderReasonView(order)));
            },
          ),
        ));
  }


  Widget _infosOrder() {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
              ),
            ]),
            SizedBox(
              height: 5.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text(
                "Pedido ${order.orderCode} - ",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
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

            order.status == StatusOrder.CANCELED.index ? _reason() : SizedBox(),
            ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return ItemOrderTileView(order.items[index]);
              },
            ),
            SizedBox(
              height: 8.0,
            ),
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
                Text('R\$ ${order.productsPrice.toStringAsFixed(2)}')
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Desconto'),
                Text('R\$ ${order.discount.toStringAsFixed(2)}')
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Taxa de entrega'),
                Text(
                  order.shipPrice == 0
                      ? "Grátis"
                      : 'R\$ ${order.shipPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      color:
                          order.shipPrice == 0 ? Colors.green : Colors.black),
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
                  'R\$ ${order.amount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(order.payment.inDelivery ?  'Pagamento na entrega' : "Crédito pelo Aqui Tem", style: TextStyle(fontWeight: FontWeight.w500)),
                order.payment.image != null
                    ? Image.asset(
                        order.payment.image,
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                      )
                    : SizedBox(),
              ],
            ),
            Divider(),
            Text(
              'Endereço de entrega',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "${order.address}, ${order.number}",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
            order.complement != ""
                ? Container(
                    width: 230.0,
                    child: Text(
                      "complemento: " + order.complement,
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 14.0),
                    ),
                  )
                : SizedBox(),
            Text(
              order.neighborhood,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Histórico',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(order.historicText),
            Divider(),
          ],
        ));
  }
  
  Widget _reason(){
    return
      Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child:  Container(
            width: 800.0,
            child:  Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Motivo do cancelamento',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      order.reason,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14.0),
                      textAlign: TextAlign.start,
                    ),

                    Text(
                      "Cancelado por: " + order.reasonBy,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 14.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ))),
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black38, width: 2.0)),
      );
  }

}
