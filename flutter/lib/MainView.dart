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

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: loadJson(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data);
            var rest = data as List;
            List<CountryInformation> list = rest
                .map<CountryInformation>(
                    (json) => CountryInformation.fromJson(json))
                .toList();
            return CardTiles(list);
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
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedView(_countryInformation))),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         Text(
                      _countryInformation.countryName.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    SizedBox(width: 5,),
                    Image.network("https://www.countryflags.io/be/flat/64.png",scale: 2.5,),
                      ],
                    ),
                   
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 60,
                          lineWidth: 5,
                          progressColor: Colors.green,
                          percent: 0.2,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(_countryInformation.aidMoney + "B"),
                          footer: Text("Aidmoney",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                          animation: true,
                          animationDuration: 1000,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        CircularPercentIndicator(
                          radius: 60,
                          lineWidth: 5,
                          progressColor: Colors.red,
                          percent: 0.2,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(_countryInformation.corruptionIndex),
                          footer: Text("Corruption",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                          animation: true,
                          animationDuration: 1000,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> loadJson() async {
  return await rootBundle.loadString("data/dummy.json");
}
