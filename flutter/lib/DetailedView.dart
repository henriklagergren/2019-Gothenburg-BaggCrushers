import 'dart:convert';

import 'package:baggcrushers/CountryInformation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetailedView extends StatelessWidget {
  final CountryInformation _countryInformation;

  DetailedView(this._countryInformation);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Country information"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          ),
      ),
      body: FutureBuilder(
          future: loadJson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data);
              List<dynamic> countries = data["countries"];
              var sectorsMap;

              for (Map<String, dynamic> country in countries) {
                if(country.containsKey(_countryInformation.countryName)){
                  sectorsMap = country[_countryInformation.countryName]["sectors"];
                }
              }

              List<Widget> widgetList = new List();

              for(var sector in sectorsMap){
                sector.forEach((key, value) => widgetList.add(new BarCard(key, value, _countryInformation.aidMoney)));
              }
              
              return DetailedViewMainBody(_countryInformation, widgetList);

            } else {
              return CircularPercentIndicator(
                radius: 10,
              );
            }
          },
        ),

    );
  }
}

 class BarCard extends StatelessWidget {
   final String _title;
   final double _value;
   final double _maxValue;

   BarCard(this._title, this._value, this._maxValue);

   @override
   Widget build(BuildContext context) {
     return Card(
       child: Column(
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Text(_title),
             ],
           ),
           Row(
             children: <Widget> [
               LinearPercentIndicator(
                 width: 200,
                 lineHeight: 14,
                 percent: _value / _maxValue,
                 backgroundColor: Colors.grey,
                 progressColor: Colors.blue,
               ),
             ]
           ),
         ],
       ),
     );
   }
 }


class DetailedViewMainBody extends StatelessWidget {
  final CountryInformation _countryInformation;
  final List<Widget> _barCardList;

  DetailedViewMainBody(this._countryInformation, this._barCardList);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  // TODO change to load from the given countrycode.
                  "https://www.countryflags.io/be/flat/64.png"
                ),
                SizedBox(width: 10,),
                Text(              
                  _countryInformation.countryName.toString().toUpperCase(),         
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 600,
                    child: ListView(children: _barCardList,)))
              ],
            ),
            //AidOverview(_countryInformation),
            //CorruptionOverview(_countryInformation),
            //Column(children: _barCardList,),
              
           
          ],
        ),
      );
  }
}




class AidOverview extends StatelessWidget {
  final CountryInformation _countryInformation;

  AidOverview(this._countryInformation);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Overview of given aid",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class CorruptionOverview extends StatelessWidget {

  final CountryInformation _countryInformation;

  CorruptionOverview(this._countryInformation);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Overview of corruption",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextCard("Corruption Index", _countryInformation.corruptionIndex.toString(), "")
            
          ],
        ),
      ],
    );
  }
}

class TextCard extends StatelessWidget {
  final String _header;
  final String _inner;
  final String _footer;

  TextCard(this._header, this._inner, this._footer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularPercentIndicator(
            radius: 50,
                lineWidth: 5,
                percent: 1,
                center: Text(_inner),
                header: Text(_header),
                footer: Text(_footer),
          ),
        ),
    );
  }
}



Future<String> loadJson() async {
  return await rootBundle.loadString("data/sectors-by-country.json");
}
