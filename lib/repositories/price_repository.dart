class PricingRepository {
  /// Price for a six-inch sandwich in GBP.
  final double sixInchPrice;

  /// Price for a footlong sandwich in GBP.
  final double footlongPrice;

  /// Create a pricing repository. Defaults: six-inch £7.00, footlong £11.00
  PricingRepository({this.sixInchPrice = 7.0, this.footlongPrice = 11.0});

  /// Calculate the total price for [quantity] sandwiches. Set [isFootlong]
  /// to true to use the footlong price, false to use the six-inch price.
  double totalPrice({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final pricePerItem = isFootlong ? footlongPrice : sixInchPrice;
    return quantity * pricePerItem;
  }
}
