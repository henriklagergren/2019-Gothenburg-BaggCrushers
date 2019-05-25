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


enum FILTERVALUES{
  CORRUPTION,
  AID
}

class _MainViewState extends State<MainView> {

 
  FILTERVALUES dropdownValue = FILTERVALUES.CORRUPTION;
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
    super.dispose();
  }

  List<CountryInformation> sortBy(FILTERVALUES property, List<CountryInformation> list){
    if(property == FILTERVALUES.CORRUPTION){
      list.sort((a, b) => a.corruptionIndex.compareTo(b.corruptionIndex));
    }else if(property == FILTERVALUES.AID){
      list.sort((a, b) => a.aidMoney.compareTo(b.aidMoney));
    }
    
    if(userSearch != ""){
    List<CountryInformation> filteredList = new List();
    for (var countryInfo in list) {
      if(countryInfo.countryName.contains(userSearch)){
        filteredList.add(countryInfo);
      }
    }
    return filteredList;
    }else{
    return list;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        setState(() {
          userSearch = "";
          _textEditingController.clear();
        });
      },
          child: Scaffold(

        appBar: PreferredSize(
          preferredSize: Size(double.maxFinite,130),
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
                      }, "Sök land",_textEditingController),
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
                   IconButton(
                    onPressed: () => setState((){
                      descending = !descending;
                    }),
                    icon: Icon(descending? MaterialCommunityIcons.getIconData("sort-descending"):MaterialCommunityIcons.getIconData("sort-ascending"),size: 30,),
                  ),
                  ],
                ),
               
            ],
            ),
          ),

        ),
        body: FutureBuilder(
              future: loadJson(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  var data = json.decode(snapshot.data);
                var rest = data["data"] as List;
                List<CountryInformation> list = rest.map<CountryInformation>((json) => CountryInformation.fromJson(json)).toList();
                list.removeWhere((value) => value == null); // This should probably not be done this way since it takes O(n)
                list = sortBy(dropdownValue, list);
                
                if(descending == true){
                  
                  List<CountryInformation> reversedList = list.reversed.toList();
                  return CardTiles(reversedList, _scrollController);
                }
                  
                  return CardTiles(list,_scrollController);
                }else{
                  return CircularPercentIndicator(radius: 10,);
                }
              },
            ),
          
      
      ),
    );
  }
}

class CardTiles extends StatelessWidget {
  final List<CountryInformation> _countries;
  final _scrollController;

  CardTiles(this._countries,this._scrollController);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
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
                    Image.network("https://www.countryflags.io/"+ _countryInformation.countryCode +"/flat/64.png",scale: 2.5,),
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
                          center: Text(_countryInformation.aidMoney.toString() + "B"),
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
                          center: Text(_countryInformation.corruptionIndex.toString()),
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
