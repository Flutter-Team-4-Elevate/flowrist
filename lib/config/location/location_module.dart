import 'package:geocoding/geocoding.dart' hide Location;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';


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
