String discountPrecent(int oldPrice, int newPrice) {
  if (oldPrice == 0) {
    return "0";
  } else {
    double x = ((oldPrice - newPrice) / oldPrice) * 100;

    return x.round().toString();
  }
}
