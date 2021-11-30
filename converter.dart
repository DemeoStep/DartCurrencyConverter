import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class Currency {
  String _name = '';
  final String _symbol;
  double _rateToUA = 1;

  Currency(this._symbol);

  double getRateToUA() => _rateToUA;

  Future<void> init() async {
    if (_symbol != 'UAH') {
      var response = await http.get(Uri.parse(
          'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?valcode=$_symbol&json'));
      Map<String, dynamic> data = (jsonDecode(response.body) as List).first;
      _rateToUA = data['rate'];
      _name = data['txt'];
    } else {
      _name = 'Українська гривня';
    }
  }

  @override
  String toString() {
    return 'name: $_name, symbol: $_symbol, rate to UAH: $_rateToUA';
  }
}

class UAH extends Currency {
  UAH() : super("UAH");
}

class USD extends Currency {
  USD() : super("USD");
}

class EUR extends Currency {
  EUR() : super("EUR");
}

class Wallet {
  final String _name;
  Currency _currency;
  double _amount = 0;

  Wallet(this._currency, this._name);

  Currency getCurrency() => _currency;

  void addAmount(double amount) {
    _amount += amount;
  }

  void transferTo(Wallet wallet, double amount) {
    if (wallet != this) {
      _amount -= amount;
      var amountInUAH = amount * _currency.getRateToUA();

      wallet.addAmount(amountInUAH / wallet.getCurrency().getRateToUA());
    }
  }

  void changeWalletCurrency(Currency newCurrency) {
    if (newCurrency != _currency) {
      var amountInUAH = _amount * _currency.getRateToUA();
      _currency = newCurrency;
      _amount = amountInUAH / _currency.getRateToUA();
    }
  }

  String getAmountFormatted() {
    return _amount.toStringAsFixed(2);
  }

  @override
  String toString() {
    return '$_name {$_currency} ' + getAmountFormatted();
  }
}

void main() async {
  var uah = UAH();
  var usd = USD();
  var eur = EUR();
  await uah.init();
  await usd.init();
  await eur.init();

  var wallet1 = Wallet(uah, "wallet_1");
  var wallet2 = Wallet(usd, "wallet_2");
  var wallet3 = Wallet(eur, "wallet_3");

  wallet1.addAmount(100);
  wallet2.addAmount(200);
  wallet3.addAmount(300);

  print(wallet1);
  print(wallet2);
  print(wallet3);

  wallet2.transferTo(wallet1, 10);
  wallet3.transferTo(wallet1, 10);

  print(wallet1);
  print(wallet2);
  print(wallet3);

  wallet1.changeWalletCurrency(uah);
  wallet2.changeWalletCurrency(uah);
  wallet3.changeWalletCurrency(uah);

  print(wallet1);
  print(wallet2);
  print(wallet3);
}
