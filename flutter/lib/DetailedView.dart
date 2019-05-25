import 'package:baggcrushers/CountryInformation.dart';
import 'package:flutter/material.dart';

class DetailedView extends StatelessWidget {
  final CountryInformation _countryInformation;

  DetailedView(this._countryInformation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_countryInformation.countryName)
        ],
      ),
    );
  }
}