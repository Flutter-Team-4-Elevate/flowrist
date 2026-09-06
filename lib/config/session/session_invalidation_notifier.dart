import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class SessionInvalidationNotifier extends ChangeNotifier {
  void notifySessionExpired();
}

@LazySingleton(as: SessionInvalidationNotifier)
class SessionInvalidationNotifierImpl extends ChangeNotifier
    implements SessionInvalidationNotifier {
  @override
  void notifySessionExpired() {
    notifyListeners();
  }
}
