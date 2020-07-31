import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/controllers/signInEmailAccount.controller.dart';
import 'package:venda_mais_client_buy/controllers/signInGoogleAccount.controller.dart';
import 'package:venda_mais_client_buy/enums/login.type.enum.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/user/login.email.view.dart';
import 'package:venda_mais_client_buy/views/user/user.view.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class LoginView extends StatelessWidget {
  final bool out;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginView(this.out);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(
            'Conta',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: outAccount(out, store),
            builder: (context, snapshot) {
              return Observer(builder: (_) {
                if (store.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                          child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/googleicon.jpg',
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Entrar com o Google',
                                  style: TextStyle(fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            textColor: Colors.black38,
                            color: Colors.white,
                            onPressed: () async {
                              SignInGoogleAccountController controller =
                                  new SignInGoogleAccountController();
                              await controller.signIn(store).then((result) {
                                if (result.success) {
                                  _onSuccess();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => UserView(true)));
                                } else {
                                  WidgetsCommons.onFail(
                                      _scaffoldKey, result.message);
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 50.0,
                          child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.email),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Text(
                                  'Entrar com outra conta',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black38),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => LoginEmailView()));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
            }));
  }

  void _onSuccess() {
    WidgetsCommons.onSucess(_scaffoldKey, 'Login efetuado com sucesso!');
  }

  Future<Null> outAccount(bool out, UserStore store) async {
    if (out && store.isLoggedIn()) {
      if (store.user.loginType == LoginType.GOOGLE.index) {
        SignInGoogleAccountController account =
            new SignInGoogleAccountController();
        account.signOutGoogle(store);
      } else if (store.user.loginType == LoginType.EMAIL.index) {
        SignInEmailAccountController account =
            new SignInEmailAccountController();
        account.signOut(store);
      }
    }
  }
}
