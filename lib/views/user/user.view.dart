import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/views/address/address.tab.view.dart';
import 'package:venda_mais_client_buy/views/home.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/utils/validators.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/controllers/user.controller.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  final bool returnInit;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = new UserController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  UserView(this.returnInit);

    @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return WillPopScope(
        onWillPop: () {
          if (returnInit) {
            if (store.isLoggedIn()) {
              if (store.user.addressList.length == 0) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => AddressTabView()));
              } else {
                _backInitMain(context);
              }
            } else {
              _backInitMain(context);
            }
          } else {
            Navigator.of(context).pop();
          }

          return Future.value(false);
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: WidgetsCommons.buttonColor(),
              title: Text(
                'Dados Usuário',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Observer(
              builder: (_) {
                if (store.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!store.isLoggedIn()) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          textColor: Colors.white,
                          color: WidgetsCommons.buttonColor(),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginView(false)));
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  _setControllersText(
                      store.user.name, store.user.email, store.user.phone);
                  return Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        Text(
                          "Nome",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              InputDecoration(hintText: store.user.name),
                          validator: FieldValidator.validateName,
                          onSaved: (val) {
                            store.user.name = val;
                          },
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              InputDecoration(hintText: store.user.email),
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                          style: TextStyle(color: Colors.black54),
                          validator: FieldValidator.validateEmail,
                          onSaved: (val) {
                            store.user.email = val;
                          },
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Celular*",
                          style: TextStyle(
                              color: store.user.phone == ""
                                  ? Colors.red
                                  : Colors.black54),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: store.user.phone,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: FieldValidator.validatePhone,
                          onSaved: (val) {
                            store.user.phone = val;
                          },
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          height: 44.0,
                          child: RaisedButton(
                            child: Text(
                              "Salvar",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            textColor: Colors.white,
                            color: WidgetsCommons.buttonColor(),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                await _controller.save(store).then((result) {
                                  if (result.success) {
                                    WidgetsCommons.onSucess(_scaffoldKey,
                                        'Usuário Alterado com sucesso!');
                                  } else {
                                    WidgetsCommons.onFail(
                                        _scaffoldKey, result.message);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )));
  }

  _backInitMain(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
  }

  void _setControllersText(String name, String email, String phone) {
    _nameController.text = name;
    _emailController.text = email;
    _phoneController.text = phone;
  }
}
