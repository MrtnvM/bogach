import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Successfully hash product ID', () {
    final testProductId = hashProductId('test-product-id');

    expect(
      testProductId,
      'b206b8cfb36a676b9e21ee2fc02801d8515ffadeb69e22cf33228fb860395d78',
    );
  });
}
