import 'package:geocoding/geocoding.dart' hide Location;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

// TODO: move this and other modules to a proper directory (suggestion)
@module
abstract class LocationModule {
  @lazySingleton
  Location location() {
    return Location();
  }

  @lazySingleton
  Geocoding geocoding() {
    return Geocoding();
  }
}
