import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'CountryInformation.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadJson(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data);
            var rest = data as List;
            List<CountryInformation> list = rest.map<CountryInformation>((json) => CountryInformation.fromJson(json)).toList();
            return CardTiles(list);
          }else{
            return CircularPercentIndicator();
          }
        },
      ),
    );
  }
}

class CardTiles extends StatelessWidget {
  final List<CountryInformation> _countries;

  CardTiles(this._countries);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _countries.length,
      itemBuilder: (BuildContext context, int index) {
        return CardTile(_countries.elementAt(index).countryName,_countries.elementAt(index).corruptionIndex,_countries.elementAt(index).aidMoney);
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
        ],
      ),
    );
  }
}

Future<String> loadJson() async {
  return await rootBundle.loadString("data/dummy.json");
}