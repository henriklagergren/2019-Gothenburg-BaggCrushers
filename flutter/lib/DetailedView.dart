import 'dart:collection';
import 'dart:convert';
import 'Components.dart';
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
            return CircularProgressIndicator();
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
          Text(
            _title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: LinearPercentIndicator(
              lineHeight: 20,
              percent: _value / _maxValue <= 0 ? 0 : _value / _maxValue,
              backgroundColor: Colors.grey[100],
              progressColor: Colors.blue,
              linearStrokeCap: LinearStrokeCap.round,
              center: Text(
                (_value / 1000000).toStringAsFixed(2) + " MSEK",
              ),
            ),
          ),
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
    return Container(
      child: ListView(
        children: [
          BasicInformation(_countryInformation, _totalAidMoney, 34, 1),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Given aid in sectors:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: _barCardList,
          ),
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
