import 'package:baggcrushers/CountryInformation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xC8C8C8),
        ),
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
                  _countryInformation.countryName.toUpperCase(),         
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                )
              ],
            ),
            AidOverview(_countryInformation),
            CorruptionOverview(_countryInformation),
          ],
        ),
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
            TextCard("Corruption Index", _countryInformation.corruptionIndex, "")
            
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