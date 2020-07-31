import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/views/user/configuration.view.dart';
import 'package:venda_mais_client_buy/views/user/login.view.dart';
import 'package:venda_mais_client_buy/views/orders/order.tab.view.dart';
import 'package:venda_mais_client_buy/views/establishment/segments.view.dart';
import 'package:venda_mais_client_buy/views/cartproducts/cart.button.view.dart';
import 'package:venda_mais_client_buy/views/widgets/customdrawer.dart';
import 'package:venda_mais_client_buy/views/widgets/widgets.commons.dart';

class HomeView extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);

    return PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    iconTheme: new IconThemeData(color: Colors.white),
                    title: Text("É pra Já Delivery",
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: WidgetsCommons.buttonColor(),
                    bottom: TabBar(
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontSize: 12.0),
                        tabs: <Widget>[
                          Tab(
                            icon: Icon(Icons.home),
                            text: 'Início',
                          ),
                          Tab(
                            icon: Icon(Icons.list),
                            text: 'Pedidos',
                          )
                        ]),
                  ),
                  body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SegmentsView(),
                        OrdersTabView(),
                      ]),
                  drawer: CustomDrawer(_pageController),
                  floatingActionButton: CartButtonView(),
                ),
              ),
              menu(context, "Meus Pedidos", OrdersTabView(), _pageController),
              menu(context, "Perfil", ConfigurationTabView(), _pageController),
              WillPopScope(
                  onWillPop: () async {
                    _pageController.jumpToPage(_pageController.initialPage);
                    return false;
                  },
                  child: Scaffold(
                    drawer: CustomDrawer(_pageController),
                    body: LoginView(true),
                  )),
            ],
          );

  }

  Widget menu(BuildContext context, String title, Widget widget,
      PageController pageController) {
    return WillPopScope(
        onWillPop: () async {
          pageController.jumpToPage(pageController.initialPage);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            title: Text(title, style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: WidgetsCommons.buttonColor(),
          ),
          drawer: CustomDrawer(pageController),
          floatingActionButton: CartButtonView(),
          body: widget,
        ));
  }
}
