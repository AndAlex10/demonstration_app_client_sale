import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/address.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class AddressDetailView extends StatelessWidget {
  final Address address;
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = new AddressController();
  AddressDetailView(this.address);

  @override
  Widget build(BuildContext context) {
    var userStore = Provider.of<UserStore>(context);
    _setData();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Endereço'),
          centerTitle: true,
        ),
        key: _scaffoldKey,
        body:
        Form(
          key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[

                WidgetsCommons.createTextFormField('Endereço', '',
                         _addressController, true, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('Número', '',
                        _numberController, true, true),

                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('Bairro', '',
                        _neighborhoodController, true, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('Complemento (Apt. Bloco, referências..)', '(Apt. Bloco, referências..)',
                        _complementController, false, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('UF', '',
                        _stateController, true, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('Cidade', '',
                        _cityController, true, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField('CEP', '',
                        _codePostalController, true, false),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          'Alterar Endereço',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: WidgetsCommons.buttonColor(),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            address.complement = _complementController.text;
                            address.number = _numberController.text;

                            _controller.alter(userStore, address).then((val){
                              if(val.success) {
                                WidgetsCommons.onSucess(_scaffoldKey,
                                    'Endereço alterado com sucesso!');
                              } else {
                                WidgetsCommons.onFail(_scaffoldKey,
                                    val.message);
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),);
  }

  _setData() {
    _addressController.text = address.address;
    _neighborhoodController.text = address.neighborhood;
    _stateController.text = address.state;
    _cityController.text = address.city;
    _numberController.text = address.number;
    _complementController.text = address.complement;
    _codePostalController.text = address.codePostal;
  }

}
