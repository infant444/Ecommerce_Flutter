String discountPrecent(int oldprice, int newprice) {
  if (oldprice == 0) {
    return "0";
  } else {
    double x = ((oldprice - newprice) / oldprice) * 100;

    return x.round().toString();
  }
}
