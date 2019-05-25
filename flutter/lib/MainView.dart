import 'package:flutter/cupertino.dart';
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


enum FILTERVALUES{
  CORRUPTION,
  AID
}

class _MainViewState extends State<MainView> {

 


  FILTERVALUES dropdownValue = FILTERVALUES.CORRUPTION;  

  List<CountryInformation> sortBy(FILTERVALUES property, List<CountryInformation> list){
    if(property == FILTERVALUES.CORRUPTION){
      list.sort((a, b) => a.corruptionIndex.compareTo(b.corruptionIndex));
    }else if(property == FILTERVALUES.AID){
      list.sort((a, b) => a.aidMoney.compareTo(b.aidMoney));
    }
    return list;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(60,60),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            DropdownButton<FILTERVALUES>(
                value: dropdownValue,
                onChanged: (FILTERVALUES newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <FILTERVALUES>[FILTERVALUES.CORRUPTION, FILTERVALUES.AID]
                    .map<DropdownMenuItem<FILTERVALUES>>((FILTERVALUES value) {
                  return DropdownMenuItem<FILTERVALUES>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
              ),
        ],),
      ),
      body: FutureBuilder(
            future: loadJson(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                var data = json.decode(snapshot.data);
                var rest = data as List;
                List<CountryInformation> list = rest.map<CountryInformation>((json) => CountryInformation.fromJson(json)).toList();
                list = sortBy(dropdownValue, list);
                
                return CardTiles(list);
              }else{
                return CircularPercentIndicator(radius: 10,);
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