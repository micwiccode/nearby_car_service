String formatPrice(int price) {
  double _price = price / 100;
  return '${_price.toStringAsFixed(2)}€';
}
