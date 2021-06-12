import 'dart:convert';
import 'package:http/http.dart' as http;
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '3D095CAE-C60C-400A-9C86-57C796B5AA98';
const apiURL = 'https://rest.coinapi.io/v1/exchangerate';
class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices= {} ;
    for(String crypto in cryptoList) {
      http.Response response = await http.get(
          Uri.parse('$apiURL/$crypto/$selectedCurrency?apiKey=$apiKey'));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      }
      else {
        print(response.statusCode);
        throw 'Problem getting Request';
      }
    }
    return cryptoPrices;
  }
}
