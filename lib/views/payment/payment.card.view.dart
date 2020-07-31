import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PaymentCardView extends StatelessWidget {
  final PaymentCard paymentCard;
  final _cardNumberController = TextEditingController();
  final _validateController = TextEditingController();
  final _securityController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _docNumberController = TextEditingController();

  PaymentCardView(this.paymentCard);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    _fillData();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          title: Text(
            'Dados do Cartão',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
          if (store.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
                child:
                    ListView(
                        padding: EdgeInsets.all(16.0),
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: TextFormField(
                                    controller: _cardNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Número do Cartão',
                                      labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                                    ),
                                    enabled: false,
                                  ),
                              ),
                              paymentCard.image != null ? Image.asset(paymentCard.image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ) : SizedBox()
                            ],
                          ),
                          SizedBox(height: 16.0,),
                          TextFormField(
                            controller: _validateController,
                            decoration: InputDecoration(
                              labelText: 'Validade',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: false,
                          ),
                          SizedBox(height: 16.0,),
                          TextFormField(
                            controller: _securityController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: false,
                          ),
                          SizedBox(height: 16.0,),
                          TextFormField(
                            controller: _customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Nome do titular',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: false,
                          ),
                          SizedBox(height: 16.0,),
                          TextFormField(
                            controller: _docNumberController,
                            decoration: InputDecoration(
                              labelText: 'CPF/CNPJ',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: false,
                          ),
                        ]
                    )
            );
          }
        }
        )
    );
  }
  void _fillData(){
    _cardNumberController.text = paymentCard.cardNumber;
    _customerNameController.text = paymentCard.customerName;
    _validateController.text = paymentCard.expirationDate;
    _docNumberController.text = paymentCard.docNumber;
    _securityController.text = "";
  }
}
