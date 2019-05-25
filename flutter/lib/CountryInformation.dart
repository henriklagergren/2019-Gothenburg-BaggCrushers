class CountryInformation {
  String _countryName;
  int _corruptionIndex;
  int _aidMoney;

  CountryInformation(this._countryName,this._corruptionIndex,this._aidMoney);

  factory CountryInformation.fromJson(Map<String,dynamic> json){
    return CountryInformation(json['country'],json['corruption'],json['money']);
  }

  get countryName => _countryName;
  get corruptionIndex => _corruptionIndex;
  get aidMoney => _aidMoney;
}