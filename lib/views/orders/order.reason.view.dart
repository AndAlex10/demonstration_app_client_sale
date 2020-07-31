
import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/order.controller.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/utils/validators.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:provider/provider.dart';

class OrderReasonView extends StatefulWidget {

  final OrderData orderData;
  OrderReasonView(this.orderData);
  @override
  _OrderReasonViewState createState() => _OrderReasonViewState(this.orderData);
}

class _OrderReasonViewState extends State<OrderReasonView> {
  final OrderData orderData;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _reasonController = TextEditingController();
  final _controller = new OrderController();
  _OrderReasonViewState(this.orderData);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('Motivo do cancelamento'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        key: _scaffoldKey,
        body:  Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                            labelText: 'Digite o motivo aqui',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                fontSize: 22.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.black)),
                        enabled: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        validator: FieldValidator.validateReason,
                      ),
                      RaisedButton(
                        child: Text(
                          'Confirmar cancelamento',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: WidgetsCommons.buttonColor(),
                        onPressed:  () async {
                          if(_formKey.currentState.validate()) {
                            orderData.reason = _reasonController.text;
                            _controller.cancel(store, orderData).then((val) async{
                              if(val.success) {
                                await _messageCancel(context, "Pedido cancelado!", false);
                                Navigator.of(context).pop();
                              } else {
                                await _messageCancel(context, val.message, true);
                                orderData.reason = "";
                                Navigator.of(context).pop();
                              }
                            });
                          }

                        }
                        ,
                      )

                    ],
                  )
                ],
              )),

        )


    );
  }
  _messageCancel(BuildContext context, message, bool erro) async {
    return Alert(
      context: context,
       type: erro ? AlertType.error : AlertType.success,
      title: message,
      buttons: [
        DialogButton(
          child: Text(
            "Fechar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }
}


