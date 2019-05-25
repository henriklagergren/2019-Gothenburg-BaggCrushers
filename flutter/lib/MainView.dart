import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'CountryInformation.dart';
import 'DetailedView.dart';

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
        return CardTile(_countries.elementAt(index));
      },
    );
  }
}

class CardTile extends StatelessWidget {
  final CountryInformation _countryInformation;

  CardTile(this._countryInformation);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedView(_countryInformation)),
        );
      },
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(_countryInformation.countryName.toUpperCase()),
              CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 5,
                  progressColor: Colors.green,
                  percent: 0.2,
                  center: Text(_countryInformation.aidMoney),
                  footer: Text("Amount of aidmoney"),
                ),
                CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 5,
                  progressColor: Colors.red,
                  percent: 0.2,
                  center: Text(_countryInformation.corruptionIndex),
                  footer: Text("Corruption index"),
                ), 
                Icon(
                  IconData(0xe5e1, fontFamily: 'MaterialIcons', matchTextDirection: true)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> loadJson() async {
  return await rootBundle.loadString("data/dummy.json");
}