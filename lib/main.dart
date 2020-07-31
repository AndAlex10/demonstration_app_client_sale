import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/home.view.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
        providers: [
          Provider<UserStore>(
            create:  (_) => UserStore(),
          ),
          Provider<CartStore>.value(value: CartStore()),
        ],
        child: MaterialApp(
            title: 'É pra Já Delivery',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.white,
            ),
            debugShowCheckedModeBanner: false,
            home: HomeView()));
  }
}
