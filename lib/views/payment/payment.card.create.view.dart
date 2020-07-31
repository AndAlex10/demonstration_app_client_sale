import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/controllers/payment.card.controller.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/enums/brand.enum.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/utils/card.number.brand.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:masked_text/masked_text.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class PaymentCardCreateView extends StatelessWidget {
  final _cardNumberController = TextEditingController();
  final _validateController = TextEditingController();
  final _securityController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final paymentCard = new PaymentCard();
  final _controller = new PaymentCardController();

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          title: Text(
            'Dados do Cartão',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
          if (userStore.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
                key: _formKey,
                child:
                    ListView(
                        scrollDirection :  Axis .horizontal,
                        padding: EdgeInsets.all(16.0),
                        children: <Widget>[
                          Card(child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _image(BrandType.VISA),
                              SizedBox(width: 5.0,),
                              _image(BrandType.MASTER),
                              SizedBox(width: 5.0,),
                              _image(BrandType.HIPERCARD),
                              SizedBox(width: 5.0,),
                              _image(BrandType.ELO),
                              SizedBox(width: 5.0,),
                              _image(BrandType.AMEX),
                              SizedBox(width: 5.0,),
                              _image(BrandType.DINERS),
                            ],
                          )),
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: MaskedTextField(
                                    maskedTextFieldController: _cardNumberController,
                                    mask: "xxxx xxxx xxxx xxxx",
                                    maxLength: 19,
                                    keyboardType: TextInputType.number,
                                    inputDecoration: InputDecoration(
                                      labelText: 'Número do Cartão',
                                      labelStyle:
                                      TextStyle(color: Colors.black38, fontSize: 20.0),
                                    ),
                                  )
                              ),
                              paymentCard.image != null
                                  ? Image.asset(paymentCard.image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              )
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(height: 12.0,),
                          MaskedTextField(
                            maskedTextFieldController: _validateController,
                            mask: "xx/xxxx",
                            maxLength: 7,
                            keyboardType: TextInputType.number,
                            inputDecoration: InputDecoration(
                              labelText: "Validade",
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                          ),
                          SizedBox(height: 12.0,),
                          MaskedTextField(
                            maskedTextFieldController: _securityController,
                            mask: "xxxx",
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputDecoration: InputDecoration(
                              labelText: "CVV",
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            controller: _customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Nome do titular',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: true,
                            validator: (text) {
                              if (text.isEmpty)
                                return 'Informe o nome do titular do cartão.';
                              else
                                return null;
                              },
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            controller: _docNumberController,
                            decoration: InputDecoration(
                              labelText: 'CPF/CNPJ',
                              labelStyle: TextStyle(color: Colors.black38, fontSize: 20.0),
                            ),
                            enabled: true,
                            keyboardType: TextInputType.number,
                            maxLength: 14,
                            validator: (text) {
                              if (CPF.isValid(text) || CNPJ.isValid(text))
                                return null;
                              else
                                return "Nũmero de documento inválido.";
                              },
                          ),
                          SizedBox(height: 16.0,),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                child: Text('Salvar', style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: WidgetsCommons.buttonColor(),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await _addCard(context, userStore);
                                  }
                                }
                                ),
                          ),
                          SizedBox(height: 16.0,),
                        ]
                    )
            );
          }
        }
        )
    );
  }

  _addCard(BuildContext context, UserStore userStore) async {
    paymentCard.populate(
        _cardNumberController.text,
        _docNumberController.text,
        _customerNameController.text,
        _validateController.text,
        _securityController.text);
    await _controller
        .addCard(userStore, paymentCard)
        .then((val) async {
          if(val.success) {
            WidgetsCommons.onSucess(_scaffoldKey, "Cartão cadastrado!");
            await Future.delayed(Duration(seconds: 1));
            Navigator.of(context).pop();
          } else {
            WidgetsCommons.onFail(_scaffoldKey, val.message);
          }
    });

  }

  Widget _image(BrandType brandType){
    return Image.asset(CardBrand.getBrandImage(EnumToString.parse(brandType)),
      width: 25,
      height: 25,
      fit: BoxFit.contain,
    );
  }
}
