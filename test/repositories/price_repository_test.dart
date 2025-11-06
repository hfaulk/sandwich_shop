import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/price_repository.dart';

void main() {
  group('PricingRepository', () {
    test('default prices calculate correctly for footlong', () {
      final repo = PricingRepository();
      final total = repo.totalPrice(quantity: 2, isFootlong: true);
      expect(total, 22.0);
    });

    test('default prices calculate correctly for six-inch', () {
      final repo = PricingRepository();
      final total = repo.totalPrice(quantity: 3, isFootlong: false);
      expect(total, 21.0);
    });

    test('zero quantity returns 0', () {
      final repo = PricingRepository();
      final total = repo.totalPrice(quantity: 0, isFootlong: true);
      expect(total, 0.0);
    });

    test('custom prices via constructor are respected', () {
      final repo = PricingRepository(sixInchPrice: 5.5, footlongPrice: 9.25);
      expect(repo.totalPrice(quantity: 2, isFootlong: false), 11.0);
      expect(repo.totalPrice(quantity: 1, isFootlong: true), 9.25);
    });
  });
}
