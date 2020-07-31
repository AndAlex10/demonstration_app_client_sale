import 'package:flutter/material.dart';

class HomeTabView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget _buildBodyBack() => Container(

      child: Container(
        child:             Center(
          child: new Image.asset(
            'images/logovendamais.png',
            width: 250,
            height: 250,
            fit: BoxFit.fill,
          ),
        ),
      ),


    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Peça já',)
              ),
            ),
          ],
        )
      ],
    );
  }
}