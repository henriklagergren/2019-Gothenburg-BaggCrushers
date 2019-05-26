import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'CountryInformation.dart';
import 'DetailedView.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

/// FILTERVALUE is an enum representing all the possible states in the
/// sortBy dropdown box.
enum FILTERVALUE { CORRUPTION, AID, MSEKCPI, COUNTRY }

/// filtervaluesToString converts the filtervalues to a string more readable for
/// human beings.
String filtervaluesToString(FILTERVALUE value) {
  switch (value) {
    case FILTERVALUE.AID:
      {
        return "Aid";
      }
      break;

    case FILTERVALUE.CORRUPTION:
      {
        return "Corruption Index";
      }
      break;

    case FILTERVALUE.MSEKCPI:
      {
        return "MSEK/CPI";
      }
      break;
    case FILTERVALUE.COUNTRY:
      {
        return "Country";
      }
      break;
  }
}

class _MainViewState extends State<MainView> {
  FILTERVALUE dropdownValue = FILTERVALUE.MSEKCPI;
  bool descending = true;
  String userSearch = "";
  ScrollController _scrollController;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  /// sortBy takes an list and returns it sorted and filtered depending on the
  /// values of the inputted FILTERVALUE property and also the current search
  /// string.
  List<CountryInformation> sortBy(
      FILTERVALUE property, List<CountryInformation> list) {
    if (property == FILTERVALUE.CORRUPTION) {
      list.sort((a, b) => a.corruptionIndex.compareTo(b.corruptionIndex));
    } else if (property == FILTERVALUE.AID) {
      list.sort((a, b) => a.aidMoney.compareTo(b.aidMoney));
    } else if (property == FILTERVALUE.MSEKCPI) {
      list.sort((a, b) => a.calculateMSEKCPI().compareTo(b.calculateMSEKCPI()));
    } else if (property == FILTERVALUE.COUNTRY) {
      list.sort((a,b) => a.countryName.compareTo(b.countryName));
    }

    if (userSearch != "") {
      List<CountryInformation> filteredList = new List();
      for (var countryInfo in list) {
        if (countryInfo.countryName.contains(userSearch)) {
          filteredList.add(countryInfo);
        }
      }
      return filteredList;
    } else {
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          userSearch = "";
          _textEditingController.clear();
        });
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.maxFinite, 130),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                _SearchBar((search) {
                  setState(() {
                    userSearch = search;
                  });
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                }, "Search for a country", _textEditingController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "sort by: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    DropdownButton<FILTERVALUE>(
                      value: dropdownValue,
                      onChanged: (FILTERVALUE newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      items: <FILTERVALUE>[
                        FILTERVALUE.MSEKCPI,
                        FILTERVALUE.CORRUPTION,
                        FILTERVALUE.AID,
                        FILTERVALUE.COUNTRY
                      ].map<DropdownMenuItem<FILTERVALUE>>(
                          (FILTERVALUE value) {
                        return DropdownMenuItem<FILTERVALUE>(
                          value: value,
                          child: Text(filtervaluesToString(value)),
                        );
                      }).toList(),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                            descending = !descending;
                            _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          }),
                      icon: Icon(
                        descending
                            ? MaterialCommunityIcons.getIconData(
                                "sort-descending")
                            : MaterialCommunityIcons.getIconData(
                                "sort-ascending"),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: loadJson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data);
              var rest = data["data"] as List;
              List<CountryInformation> list = rest
                  .map<CountryInformation>(
                      (json) => CountryInformation.fromJson(json))
                  .toList();
              list.removeWhere((value) =>
                  value ==
                  null); // This should probably not be done this way since it takes O(n)
              list = sortBy(dropdownValue, list);

              if (descending == true) {
                List<CountryInformation> reversedList = list.reversed.toList();
                return CardTiles(reversedList, _scrollController);
              }

              return CardTiles(list, _scrollController);
            } else {
              return CircularPercentIndicator(
                radius: 10,
              );
            }
          },
        ),
      ),
    );
  }
}


/// CardTiles is the ListView wrapper of all the individual CardTile.
class CardTiles extends StatelessWidget {
  final List<CountryInformation> _countries;
  final _scrollController;

  CardTiles(this._countries, this._scrollController);

  @override
  Widget build(BuildContext context) {
    double totalAidMoney = sumAidMoney(_countries);
    return ListView.builder(
      controller: _scrollController,
      itemCount: _countries.length,
      itemBuilder: (BuildContext context, int index) {
        return CardTile(_countries.elementAt(index), totalAidMoney);
      },
    );
  }

  double sumAidMoney(List<CountryInformation> _countries) {
    double sum = 0;
    for (var country in _countries) {
      sum += country.aidMoney;
    }
    return sum;
  }
}

class CardTile extends StatelessWidget {
  final CountryInformation _countryInformation;
  final double _totalAidMoney;

  CardTile(this._countryInformation, this._totalAidMoney);

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

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailedView(_countryInformation, _totalAidMoney))),
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
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _countryInformation.countryName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.network(
                          "https://www.countryflags.io/" +
                              _countryInformation.countryCode +
                              "/flat/(.png",
                          scale: 2.5,
                        ),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 15),
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
                            _countryInformation.corruptionIndex
                                    .toStringAsFixed(0) +
                                "\nCPI",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          footer: Text(
                            "Corruption Index",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 15),
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
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _countryInformation
                                  .calculateMSEKCPI()
                                  .toStringAsFixed(3),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "MSEK/CPI",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SearchBar extends StatelessWidget {
  final Function _onChange;
  final String _hintText;
  final TextEditingController _controller;

  _SearchBar(this._onChange, this._hintText, this._controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      elevation: 5,
      child: new TextField(
        controller: _controller,
        decoration: new InputDecoration(
            hintText: _hintText,
            border: InputBorder.none,
            prefixIcon: new Icon(
              Icons.search,
              size: 19,
            )),
        onChanged: (String search) {
          _onChange(search);
        },
      ),
    );
  }
}


Future<String> loadJson() async {
  return await rootBundle.loadString("data/data.json");
}
