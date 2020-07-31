import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/controllers/signInEmailAccount.controller.dart';
import 'package:venda_mais_client_buy/utils/validators.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class SignUpView extends StatelessWidget {
  final signInEmailAccountController = new SignInEmailAccountController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
            if(store.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else { return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Nome Completo"
                    ),
                    validator: FieldValidator.validateName
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText:  "Celular*",
                        hintStyle: TextStyle(color: _phoneController.text == "" ? Colors.red : Colors.black38),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: FieldValidator.validateName
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: FieldValidator.validateEmail
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    validator: FieldValidator.validatePassword
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Criar Conta",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: WidgetsCommons.buttonColor(),
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          signInEmailAccountController.signUp(store, _nameController.text, _emailController.text,
                              _passController.text, _phoneController.text).then((result){
                            if (result.success) {
                              _onSuccess(context);
                            } else {
                              WidgetsCommons.onFail(_scaffoldKey, result.message);
                            }
                          });

                        }
                      },
                    ),
                  ),
                ],
              ),
            );}
          },
        )
    );
  }

  void _onSuccess(BuildContext context){
    WidgetsCommons.onSucess(_scaffoldKey, "Usuário criado com sucesso!");
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

}

