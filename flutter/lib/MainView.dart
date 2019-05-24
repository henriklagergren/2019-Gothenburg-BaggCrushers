import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CardTiles(),
    );
  }
}

class CardTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CardTile();
      },
    );
  }
}

class CardTile extends StatelessWidget {
  final String _country;
  final String _corruption;
  final String _money;

  CardTile(this._country,this._corruption,this._money);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(_country),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
