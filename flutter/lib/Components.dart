import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'CountryInformation.dart';

class BasicInformation extends StatelessWidget {
  final CountryInformation _countryInformation;
  final double _totalAidMoney;
  final double _textSize;
  final double _flagScale;

  BasicInformation(this._countryInformation,this._totalAidMoney,this._textSize,this._flagScale);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                              fontWeight: FontWeight.w700, fontSize: _textSize),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.network(
                          "https://www.countryflags.io/" +
                              _countryInformation.countryCode +
                              "/flat/64.png",
                          scale: _flagScale,
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
                          progressColor: getCorruptionColor(),
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
          );
  }

  Color getCorruptionColor(){
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

    return Color.fromRGBO(red, green, 0, 1);
  }
}