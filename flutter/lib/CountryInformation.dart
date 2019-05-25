class CountryInformation {
  String _countryName;
  double _corruptionIndex;
  double _aidMoney;
  String _countryCode;

  CountryInformation(this._countryName,this._corruptionIndex,this._aidMoney, this._countryCode);

  factory CountryInformation.fromJson(Map<String,dynamic> json){
    if(json['aid_received_sek'] == null || json['CPI'] == null){
      return null;
    }
    return CountryInformation(json['country'],json['CPI'],json['aid_received_sek'], json["country_code"]);
  }

  get countryName => _countryName;
  get corruptionIndex => _corruptionIndex;
  get aidMoney => _aidMoney;
  get countryCode => _countryCode;
}