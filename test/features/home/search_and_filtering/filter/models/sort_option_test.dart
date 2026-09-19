import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/models/sort_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortOption', () {
    test('should map each enum value to the correct api string', () {
      expect(SortOption.lowestPrice.apiValue, AppConstants.sortPriceLowToHigh);
      expect(SortOption.highestPrice.apiValue, AppConstants.sortPriceHighToLow);
      expect(SortOption.newest.apiValue, AppConstants.sortNewestFirst);
      expect(SortOption.oldest.apiValue, AppConstants.sortOldestFirst);
    });
  });
}
