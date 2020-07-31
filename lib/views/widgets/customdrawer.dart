import 'package:flutter/material.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/widgets/custom.clipper.dart';
import 'package:venda_mais_client_buy/views/widgets/drawer.view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.center,
              end: Alignment.bottomCenter)),
    );
    return ClipPath(
        clipper: MyCustomClipper(),
    child: Drawer(
    child: Stack(
    children: <Widget>[
    _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 22.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 160.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Observer(builder: (_) {
                              return Row(
                                children: <Widget>[
                                  store.isLoggedIn()
                                      ? store.user.photo != null ? Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  store.user.photo))))

                                      : WidgetsCommons.noPhoto() : WidgetsCommons.noPhoto(),


                                ],
                              );
                            })),

                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Observer(builder: (_) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              !store.isLoggedIn()
                                  ? SizedBox(
                                      height: 44.0,
                                      child: RaisedButton(
                                        child: Text(
                                          "ENTRAR",
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        textColor: Colors.white,
                                        color: Colors.green,
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(false)));
                                        },
                                      ),
                                    )
                                  : Container(
                                      width: 230.0,
                                      child: Text(
                                        "Olá " + store.user.name,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ],
                          );
                        })),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Inicio', pageController, 0),
              DrawerTile(
                  Icons.playlist_add_check, 'Meus Pedidos', pageController, 1),
              DrawerTile(Icons.list, 'Perfil', pageController, 2),
              DrawerTile(Icons.input, 'Sair', pageController, 3),
            ],
          )
        ],
      ),
    ));
  }
}




