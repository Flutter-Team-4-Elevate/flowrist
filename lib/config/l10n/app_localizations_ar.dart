// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get home => 'الرئيسية';

  @override
  String get categories => 'الأقسام';

  @override
  String get cart => 'السلة';

  @override
  String get profile => 'حسابي';

  @override
  String get generalValidationError => 'إدخال غير صالح';

  @override
  String get emptyValidationError => 'هذا الحقل مطلوب';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get enterFirstName => 'أدخل الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get enterLastName => 'أدخل اسم العائلة';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get invalidEmailError => 'البريد الإلكتروني غير صالح';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get gender => 'الجنس';

  @override
  String get female => 'أنثى';

  @override
  String get male => 'ذكر';

  @override
  String get termsAndConditionsPrefix => 'بإنشاء حساب، فإنك توافق على ';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get passwordLengthError => 'يجب ألا تقل كلمة المرور عن 8 أحرف';

  @override
  String get passwordUppercaseError =>
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z)';

  @override
  String get passwordLowercaseError =>
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (a-z)';

  @override
  String get passwordNumberError =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9)';

  @override
  String get passwordSpecialCharError =>
      'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل (#?!@\$%^&*-)';

  @override
  String get registrationSuccessful => 'تم إنشاء الحساب بنجاح!';

  @override
  String get passwordsDoNotMatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get loginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get loginRequiredMessage => 'يرجى تسجيل الدخول لاستخدام هذه الميزة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgetPassword => 'نسيت كلمة المرور؟';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get loginSuccessfully => 'تم تسجيل الدخول بنجاح';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDescription =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق (OTP).';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get verifyOtp => 'تأكيد الرمز';

  @override
  String get otp => 'رمز التحقق';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String otpSentTo(Object email) {
    return 'أدخل رمز التحقق المرسل إلى $email';
  }

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String resendOtpIn(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get invalidOtp => 'يجب أن يتكون رمز التحقق من 6 أرقام';

  @override
  String get seconds => 'ثوانٍ';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmYourPassword => 'أكّد كلمة المرور';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب ألا تقل كلمة المرور عن 8 أحرف';

  @override
  String get passwordMustContainUppercase =>
      'يجب أن تحتوي كلمة المرور على حرف كبير';

  @override
  String get passwordMustContainLowercase =>
      'يجب أن تحتوي كلمة المرور على حرف صغير';

  @override
  String get passwordMustContainNumber => 'يجب أن تحتوي كلمة المرور على رقم';

  @override
  String get passwordMustContainSpecialCharacter =>
      'يجب أن تحتوي كلمة المرور على رمز خاص';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordResetSuccessfully => 'تمت إعادة تعيين كلمة المرور بنجاح';

  @override
  String get productDescription => 'الوصف';

  @override
  String get productIncludes => 'يحتوي على';

  @override
  String get productInStock => 'متوفر بالمخزون';

  @override
  String get productOutOfStock => 'غير متوفر';

  @override
  String get productAvailableStock => 'الكمية المتاحة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get search => 'بحث';

  @override
  String get egp => 'ج.م';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get bestSeller => 'الأكثر مبيعاً';

  @override
  String get bestSellerSubtitle => 'تألق مع تشكيلتنا الأكثر طلباً';

  @override
  String get occasion => 'المناسبة';

  @override
  String get flowery => 'فلاوري';

  @override
  String get deliverTo => 'التوصيل إلى';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get bestSellers => 'الأكثر مبيعاً';

  @override
  String get items => 'منتجات';

  @override
  String get availableStock => 'الكمية المتاحة';

  @override
  String get yourCartIsEmpty => 'سلتك فارغة';

  @override
  String get subTotal => 'المجموع الفرعي';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get total => 'الإجمالي';

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get selectAddress => 'اختر العنوان';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get addNewaddress => 'إضافة عنوان جديد';

  @override
  String get noAddressessaved => 'لا توجد عناوين محفوظة';

  @override
  String get youHaveNosaved => 'ليس لديك أي عنوان محفوظ حتى الآن.';

  @override
  String get addOneTocomplete => 'أضف عنواناً لتكتمل تجربة الإهداء.';

  @override
  String get address => 'العنوان';

  @override
  String get locationPermissionNeeded => 'إذن الموقع مطلوب';

  @override
  String get allowAccessDescription => 'اسمح بالوصول لتحديد عنوانك تلقائياً.';

  @override
  String get allowAccess => 'السماح بالوصول';

  @override
  String get couldntResolveAddress => 'تعذر تحديد العنوان';

  @override
  String get couldntResolveAddressDescription =>
      'تم تحديد الإحداثيات ولكن تعذر العثور على اسم الشارع. أدخله يدوياً أو ';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get findingLocation => 'جارٍ تحديد موقعك...';

  @override
  String get enterAddress => 'أدخل العنوان';

  @override
  String get recipientName => 'اسم المستلم';

  @override
  String get enterRecipientName => 'أدخل اسم المستلم';

  @override
  String get city => 'المدينة';

  @override
  String get cairo => 'القاهرة';

  @override
  String get area => 'المنطقة';

  @override
  String get october => 'أكتوبر';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get turnOnLocation => 'تفعيل خدمات الموقع';

  @override
  String get locationDisabledDescription =>
      'خدمة تحديد الموقع متوقفة على جهازك. يرجى تفعيلها للعثور على عنوانك تلقائياً.';

  @override
  String get enableLocation => 'تفعيل الموقع';

  @override
  String get enterAddressManually => 'إدخال العنوان يدوياً';

  @override
  String get locationAccessBlocked => 'تم حظر الوصول إلى الموقع';

  @override
  String get locationBlockedDescription =>
      'لقد قمت بتعطيل إذن الموقع للتطبيق. قم بتفعيله من الإعدادات لاستخدام عنوانك الحالي.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get locationPermissionDeniedSettingsMessage =>
      'تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات لاستخدام التحديد التلقائي للعنوان.';

  @override
  String get mapConfigWarning => 'الخرائط عالية الدقة غير متاحة';

  @override
  String get mapConfigWarningDescription =>
      'يتم استخدام مزود خرائط أساسي. قد تنقص بعض التفاصيل.';

  @override
  String get addressSavedSuccessfully => 'تم حفظ العنوان بنجاح';

  @override
  String get selectCityAndArea => 'يرجى تحديد المدينة والمنطقة';

  @override
  String get searchForAnyProductYouWant => 'ابحث عن أي منتج تريده';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get lowestPrice => 'الأقل سعراً';

  @override
  String get highestPrice => 'الأعلى سعراً';

  @override
  String get newest => 'الأحدث';

  @override
  String get oldest => 'الأقدم';

  @override
  String get filter => 'تصفية';

  @override
  String get clear => 'مسح';

  @override
  String get activeSessions => 'الجلسات النشطة';

  @override
  String get noActiveSessions => 'لا توجد جلسات نشطة';

  @override
  String get thisDevice => 'هذا الجهاز';

  @override
  String get activeNow => 'نشط الآن';

  @override
  String get revoke => 'إنهاء';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get logOutEverywhere => 'تسجيل الخروج من كل الأجهزة';

  @override
  String get revokeSessionTitle => 'إنهاء الجلسة';

  @override
  String get revokeSessionConfirmation =>
      'هل أنت متأكد أنك تريد تسجيل الخروج من هذا الجهاز؟';

  @override
  String get revokeAllTitle => 'تسجيل الخروج من كل الأجهزة';

  @override
  String get revokeAllConfirmation =>
      'سيؤدي هذا إلى إنهاء جميع الجلسات النشطة باستثناء جهازك الحالي. متابعة؟';

  @override
  String get sessionRevokedSuccessfully => 'تم إنهاء الجلسة بنجاح';

  @override
  String get currentSession => 'الجلسة الحالية';

  @override
  String get allSessionsRevokedSuccessfully => 'تم إنهاء جميع الجلسات بنجاح';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get active => 'نشطة';

  @override
  String get completed => 'مكتملة';

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get reorder => 'إعادة الطلب';

  @override
  String get deliveredOn => 'تم التوصيل في';

  @override
  String get noOrdersFound => 'لا توجد طلبات';

  @override
  String get orderNumberPrefix => 'رقم الطلب:';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get status => 'الحالة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get paymentStatus => 'حالة الدفع';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get deliveryTime => 'وقت التوصيل';

  @override
  String get instantArriveBy => 'فوري، يصل بحلول';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get itIsAGift => 'إنها هدية';

  @override
  String get enterTheName => 'أدخل الاسم';

  @override
  String get name => 'الاسم';

  @override
  String get enterThePhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get couldnotopenpaymentpage => 'تعذر فتح صفحة الدفع';

  @override
  String get paymentsessionURLismissing => 'رابط جلسة الدفع غير موجود';

  @override
  String get invalidpaymentURL => 'رابط دفع غير صالح';

  @override
  String get pleaseselectapaymentmethod => 'يرجى تحديد طريقة الدفع';

  @override
  String get pleaseenterrecipientname => 'يرجى إدخال اسم المستلم';

  @override
  String get pleaseenterrecipientphone => 'يرجى إدخال رقم هاتف المستلم';

  @override
  String get notification => 'الإشعارات';

  @override
  String get language => 'اللغة';

  @override
  String get current_language => 'العربية';

  @override
  String get about_us => 'من نحن';

  @override
  String get terms_and_conditions => 'الشروط والأحكام';

  @override
  String get app_version => 'v 6.3.0 - (446)';

  @override
  String get savedAddress => 'العناوين المحفوظة';

  @override
  String get orderDate => 'تاريخ الطلب';

  @override
  String get orderIdRequired => 'معرف الطلب مطلوب';

  @override
  String get confirmLogout => 'تأكيد تسجيل الخروج!!';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get allPricesIncludeTax => 'جميع الأسعار تتضمن الضريبة';
}
