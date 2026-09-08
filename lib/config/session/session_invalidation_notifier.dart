import 'package:flutter/foundation.dart';

abstract interface class SessionInvalidationNotifier implements Listenable {
  void notifySessionExpired();
}
