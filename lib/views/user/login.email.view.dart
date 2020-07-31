import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/controllers/signInEmailAccount.controller.dart';
import 'package:venda_mais_client_buy/views/user/signup.view.dart';
import 'package:venda_mais_client_buy/views/user/user.view.dart';
import 'package:venda_mais_client_buy/utils/validators.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class LoginEmailView extends StatelessWidget {
  final signInEmailAccountController = new SignInEmailAccountController();
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
          title: Text("Conta"),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
            if(store.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else {return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                        if(_emailController.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Insira seu e-mail para recuperação!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              )
                          );
                        else {
                          signInEmailAccountController.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Confira seu e-mail!"),
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                duration: Duration(seconds: 2),
                              )
                          );
                        }
                      },
                      child: Text("Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Entrar",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: WidgetsCommons.buttonColor(),
                      onPressed: () async{
                        if(_formKey.currentState.validate()) {
                          signInEmailAccountController.signIn(
                              store, _emailController.text,
                              _passController.text).then((val) {
                            if (val.success) {
                              _onSuccess();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => UserView(true)));
                            } else {
                              WidgetsCommons.onSucess(
                                  _scaffoldKey, val.message);
                            }
                          });
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Criar Nova Conta",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: WidgetsCommons.buttonColor(),
                      onPressed: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => SignUpView()));
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

  void _onSuccess(){
    WidgetsCommons.onSucess(_scaffoldKey, 'Login efetuado com sucesso!');
  }

}