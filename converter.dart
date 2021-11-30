abstract class Currency {
  final String _name;
  final String _symbol;
  final double _rateToUA;

  Currency(this._name, this._symbol, this._rateToUA);
  
  double getRateToUA() => _rateToUA;

  @override
  String toString() {
    return 'name: $_name, symbol: $_symbol, rate to UAH: $_rateToUA';
  }
}

class UAH extends Currency {
  UAH() : super("Ukrainian Hryvna", "UAH", 1);
}

class USD extends Currency {
  USD() : super("US Dollar", "USD", 27.12);
}

class EUR extends Currency {
  EUR() : super("Euro", "EUR", 30.45);
}

class Wallet {
  String _name;
  Currency _currency;
  double _amount = 0;

  Wallet(this._currency, this._name);

  Currency getCurrency() => _currency;

  void addAmount(double amount) {
    _amount += amount;
  }

  void transferTo(Wallet wallet, double amount) {
    if(wallet != this) {
      _amount -= amount;
      var amountInUAH = amount * _currency.getRateToUA();

      wallet.addAmount(amountInUAH / wallet.getCurrency().getRateToUA());
    }
  }

  void changeWalletCurrency(Currency newCurrency) {
    if(newCurrency != _currency) {
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

void main() {
  var wallet1 = Wallet(UAH(), "wallet_1");
  var wallet2 = Wallet(USD(), "wallet_2");
  var wallet3 = Wallet(EUR(), "wallet_3");

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
  
  wallet1.changeWalletCurrency(UAH());
  wallet2.changeWalletCurrency(UAH());
  wallet3.changeWalletCurrency(UAH());
  
  print(wallet1);
  print(wallet2);
  print(wallet3);
}
