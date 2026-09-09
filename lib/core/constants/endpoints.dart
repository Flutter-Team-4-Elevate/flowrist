abstract final class Endpoints {
  static const baseUrl = 'http://10.0.2.2:5000/';
  static const register = 'api/identity/auth/register';
  static const login = 'api/identity/auth/login';
  static const refreshToken = 'api/identity/auth/refresh-token';
  static const sessions = 'api/identity/auth/sessions';
  static String deleteSession(String sessionId) =>
      'api/identity/auth/sessions/$sessionId';

  static const occasions = 'api/catalog/occasions';
  static const categories = 'api/catalog/categories';
  static const products = 'api/catalog/products';
  static const home = 'api/catalog/home/layout';
  static const getAllAddress = 'api/address-cart/addresses';
  static const createCheckOut = 'api/payment/checkout';
  static const deliveryFee = 'api/orders/checkout/estimate-delivery';
  static const placeOrder = 'api/orders/place';
  static const addressId = 'addressId';
  static const setDefaultAddress =
      'api/address-cart/users/me/addresses/{addressId}/default';
  static const String forgetPassword = 'auth/forget-password';
  static const String verifyOTP = 'auth/otp-verification';
  static const String resetPassword = 'auth/reset-password';
  static const String productDetails = '/api/catalog/products';
  static const String cart = 'api/address-cart/cart';
  static const String cartItems = 'api/address-cart/cart/items';
  static const String governorates = 'api/address-cart/locations/governorates';
  static const String cities =
      'api/address-cart/locations/governorates/{governorateId}/cities';
  static const String saveAddress = 'api/address-cart/users/me/addresses';
  static const String deleteAddress =
      'api/address-cart/users/me/addresses/{addressId}';
  static const String updateAddress =
      'api/address-cart/users/me/addresses/{addressId}';
  static const String searchProducts = 'api/catalog/products/search';
  static const String dateFormatDelivery = 'dd MMM yyyy, hh:mm a';
  static const String cash = 'cash';
  static const String creditCard = 'creditCard';
  static const String card = 'Card';
  static const String cod = 'Cod';
  static const String stripe = 'Stripe';
  static const String idempotencyKey = "Idempotency-Key";
  static const String cartId = 'CartId';
  static const String orders = 'api/orders';
}
