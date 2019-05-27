import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'CountryInformation.dart';
import 'DetailedView.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'Components.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
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
                      ].map<DropdownMenuItem<FILTERVALUE>>((FILTERVALUE value) {
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
              double totalAidMoney = sumAidMoney(list);
              list = sortBy(dropdownValue, list);

              if (descending == true) {
                List<CountryInformation> reversedList = list.reversed.toList();
                return CardTiles(reversedList, _scrollController,totalAidMoney);
              }

              return CardTiles(list, _scrollController,totalAidMoney);
            } else {
              return Center(child:CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  double sumAidMoney(List<CountryInformation> _countries) {
    double sum = 0;
    for (var country in _countries) {
      sum += country.aidMoney;
    }
    return sum;
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
      list.sort((a, b) => a.countryName.compareTo(b.countryName));
    }

    if (userSearch != "") {
      List<CountryInformation> filteredList = new List();
      for (var countryInfo in list) {
        if (countryInfo.countryName.toLowerCase().contains(userSearch.toLowerCase())) {
          filteredList.add(countryInfo);
        }
      }
      return filteredList;
    } else {
      return list;
    }
  }

  /// filtervaluesToString converts the filtervalues to a string more readable for
  /// human beings.
  String filtervaluesToString(FILTERVALUE value) {
    switch (value) {
      case FILTERVALUE.AID:
        return "Aid";
      
      case FILTERVALUE.CORRUPTION:
        return "Corruption Index";

      case FILTERVALUE.MSEKCPI:
        return "MSEK/CPI";

      case FILTERVALUE.COUNTRY:
        return "Country";
    }
  }
}

/// CardTiles is the ListView wrapper of all the individual CardTile.
class CardTiles extends StatelessWidget {
  final List<CountryInformation> _countries;
  final _scrollController;
  final double _totalAidMoney;

  CardTiles(this._countries, this._scrollController,this._totalAidMoney);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _countries.length,
      itemBuilder: (BuildContext context, int index) {
        return CardTile(_countries.elementAt(index), _totalAidMoney);
      },
    );
  }
}

class CardTile extends StatelessWidget {
  final CountryInformation _countryInformation;
  final double _totalAidMoney;

  CardTile(this._countryInformation, this._totalAidMoney);

  @override
  Widget build(BuildContext context) {
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
                child:BasicInformation(_countryInformation, _totalAidMoney, 20, 2.5),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 24,
              ),
            ]
              
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

/// FILTERVALUE is an enum representing all the possible states in the
/// sortBy dropdown box.
enum FILTERVALUE { CORRUPTION, AID, MSEKCPI, COUNTRY }

Future<String> loadJson() async {
  return await rootBundle.loadString("data/data.json");
}
