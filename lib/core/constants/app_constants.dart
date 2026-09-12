abstract final class AppConstants {
  static const String storageTokenKey = 'userTokenKey';
  static const String rememberMeKey = 'rememberMeKey';
  static const String guestModeKey = 'guestModeKey';
  static const String categoryId = 'categoryId';
  static const String occasionId = 'OccasionId';
  static const String itemIdKey = 'itemId';
  static const String appPackageName = 'com.elevate.t5.flowrist';
  static const String mapTilerApiKeyQueryParam = 'key';
  static const String mapTilerUrlTemplate =
      'https://api.maptiler.com/maps/dataviz-light/256/{z}/{x}/{y}.png?$mapTilerApiKeyQueryParam={$mapTilerApiKeyQueryParam}';

  static const String mapFallbackUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String arabicLocaleCode = 'ar';
  static const String searchParamQ = 'q';
  static const String searchParamSort = 'sort';
  static const String searchParamPage = 'Page';
  static const String searchParamPageSize = 'PageSize';
  static const String sortParam = 'sort';
  static const String sortPriceLowToHigh = 'PriceLowToHigh';
  static const String sortPriceHighToLow = 'PriceHighToLow';
  static const String sortNewestFirst = 'NewestFirst';
  static const String sortOldestFirst = 'OldestFirst';
}
