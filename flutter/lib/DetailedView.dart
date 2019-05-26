import 'dart:convert';

import 'package:baggcrushers/CountryInformation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetailedView extends StatelessWidget {
  final CountryInformation _countryInformation;
  final double _totalAidMoney;

  DetailedView(this._countryInformation, this._totalAidMoney);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
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

            // Parse jsonfile into workable objects below.
            var data = json.decode(snapshot.data);
            List<dynamic> countries = data["countries"];
            var sectorsMap;

            // countries is a list containing maps with one key-value pairs each.
            for (Map<String, dynamic> country in countries) {
              if (country.containsKey(_countryInformation.countryName)) {
                sectorsMap =
                    country[_countryInformation.countryName]["sectors"];
              }
            }

            List<Widget> widgetList = new List();
            List<_tempObject> tempList = new List();


            // Create a bar card for each sector.
            for (var sector in sectorsMap) {
              // sector.forEach((key, value) => widgetList
              //    .add(new BarCard(key, value, _countryInformation.aidMoney)));
              sector.forEach((key, value) => tempList.add(new _tempObject(key, value)));
            }

            tempList.sort((a, b) => a.value.compareTo(b.value));

            for (_tempObject tempObject in tempList) {
              widgetList.add(new BarCard(tempObject._title, tempObject._value, _countryInformation.aidMoney));
            }

            return DetailedViewMainBody(
                _countryInformation, widgetList, _totalAidMoney);
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

// Temporary object to be able to sort. Should probably do this in another way later.
class _tempObject {
  final String _title;
  final double _value;

  _tempObject(this._title, this._value);

  get title => _title;
  get value => _value;
}



/// BarCard is an widget responsible for displaying a card containing a title
/// and a bar that fills up depending on how close the _value parameter is to the
/// _maxValue parameter.
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
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Row(children: <Widget>[
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width / 100 * 98,
              lineHeight: 20,
              percent: _value / _maxValue <= 0 ? 0 : _value / _maxValue,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
              center: Text(
                (_value / 1000000).toStringAsFixed(2) + " MSEK",
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class DetailedViewMainBody extends StatelessWidget {
  final CountryInformation _countryInformation;
  final List<Widget> _barCardList;
  final double _totalAidMoney;

  DetailedViewMainBody(
      this._countryInformation, this._barCardList, this._totalAidMoney);

  @override
  Widget build(BuildContext context) {
    int green = (_countryInformation.corruptionIndex * 4).toInt();
    int red = ((100 - _countryInformation.corruptionIndex) * 2.8).toInt();
    if (red < 0) {
      red = 0;
    } else if (red > 255) {
      red = 255;
    }

    if (green < 0) {
      green = 0;
    } else if (green > 255) {
      green = 255;
    }

    Color color = Color.fromRGBO(red, green, 0, 1);

    return Container(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _countryInformation.countryName.toString().toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.network(
                  "https://www.countryflags.io/" +
                      _countryInformation.countryCode +
                      "/flat/64.png"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularPercentIndicator(
                radius: 70,
                lineWidth: 6,
                progressColor: Colors.blue,
                percent: _countryInformation.aidMoney < 0
                    ? 0
                    : _countryInformation.aidMoney / _totalAidMoney,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  _countryInformation.aidMoney / 1000000 < 100
                      ? (_countryInformation.aidMoney / 1000000)
                              .toStringAsFixed(2) +
                          "\nMSEK"
                      : (_countryInformation.aidMoney / 1000000)
                              .toStringAsFixed(1) +
                          "\nMSEK",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                footer: Text(
                  "Aid",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                ),
                animation: true,
                animationDuration: 1000,
              ),
              SizedBox(
                width: 10,
              ),
              CircularPercentIndicator(
                radius: 70,
                lineWidth: 6,
                progressColor: color,
                percent: _countryInformation.corruptionIndex / 100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  _countryInformation.corruptionIndex.toStringAsFixed(0) +
                      "\nCPI",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                footer: Text(
                  "Corruption Index",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                ),
                animation: true,
                animationDuration: 1000,
              ),
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  width: 1,
                  height: 70,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    _countryInformation.calculateMSEKCPI().toStringAsFixed(3),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "MSEK/CPI",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20,),

         ListView(
           shrinkWrap: true,
           physics: ClampingScrollPhysics(),
           children: _barCardList,
         ),

         /* Row(
            children: <Widget>[

              Expanded(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 100 * 65,
                      child: ListView(
                        children: _barCardList,
                      )))
            ],
          ),*/
        ],
      ),
    );
  }
}

/// loadJson is responsible for loading the json-file containing the sectors by
/// country. In the future this should probably be refactored to a backend
/// service where we can make a REST call for the specific country instead of
/// loading the data for all countries every time.
Future<String> loadJson() async {
  return await rootBundle.loadString("data/sectors-by-country.json");
}
