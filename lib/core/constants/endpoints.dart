abstract final class Endpoints {
  static const baseUrl = 'http://10.0.2.2:5000/';
  static const register = 'api/identity/auth/register';
static const occasions = 'api/catalog/occasions';
  static const categories = 'api/catalog/categories';
  static const products = 'api/catalog/products';
  static const home = 'api/catalog/home/layout';
  static const getAllAddress = 'api/address-cart/addresses';
  static const addressId = 'addressId';
  static const setDefaultAddress =
      'api/address-cart/users/me/addresses/{addressId}/default';
  static const String forgetPassword = 'api/identity/auth/forget-password';
  static const String verifyOTP = 'api/identity/auth/otp-verification';
  static const String resetPassword = 'api/identity/auth/reset-password';static const String productDetails = '/api/catalog/products';
  static const String cart = 'api/address-cart/cart';
  static const String cartItems = 'api/address-cart/cart/items';
  static const String governorates = 'api/address-cart/locations/governorates';
  static const String cities =
      'api/address-cart/locations/governorates/{governorateId}/cities';
  static const String saveAddress = 'api/address-cart/users/me/addresses';
  static const String searchProducts = 'api/catalog/products/search';
}
