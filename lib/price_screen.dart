import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  Widget getAndroidDropdown() {
    List<DropdownMenuItem> dropDownItems = [];
    for (String currency in currenciesList) {
      DropdownMenuItem newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  Widget getiOSPicker() {
    List<Text> pickeriOS = [];
    for (String currency in currenciesList) {
      pickeriOS.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        },
        children: pickeriOS,
    );
  }

  Map <String, String> cryptoValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting=false;
      setState(() {
        cryptoValues = data;
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
   List<CryptoCards> cryptoCards = [];
   for (String crypto in cryptoList) {
     cryptoCards.add(
       CryptoCards(
         cryptoCurrency: crypto,
         selectedCurrency: selectedCurrency,
         value: isWaiting ? '?' : cryptoValues[crypto],
       ),
     );
   }
   return Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: cryptoCards,
   );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getiOSPicker() : getAndroidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCards extends StatelessWidget {
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  const CryptoCards({this.value,this.selectedCurrency,this.cryptoCurrency});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

