/// A helper class for calculating selling price and discount percentage based on original price.
class PriceCalculator {
  /// Calculates the selling price given the original price and discount percentage.
  /// Returns the price rounded to two decimal places.
  static double calculateSellingPrice(double originalPrice, int discountPercent) {
    final price = originalPrice * (1 - discountPercent / 100);
    return double.parse(price.toStringAsFixed(2));
  }

  /// Calculates the discount percentage given the original price and selling price.
  /// Returns an integer discount (0 to 100).
  static int calculateDiscountPercent(double originalPrice, double sellingPrice) {
    if (originalPrice <= 0) return 0;
    final discount = ((1 - (sellingPrice / originalPrice)) * 100);
    final rounded = discount.clamp(0, 100);
    return rounded.round();
  }
}
