import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class SessionInvalidationNotifier extends ChangeNotifier {
  void notifySessionExpired();
}

@lazySingleton
@Injectable(as: SessionInvalidationNotifier)
class SessionInvalidationNotifierImpl extends ChangeNotifier
    implements SessionInvalidationNotifier {
  @override
  void notifySessionExpired() {
    notifyListeners();
  }
}
