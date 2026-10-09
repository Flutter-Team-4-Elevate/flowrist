import 'dart:developer';

import 'package:geocoding/geocoding.dart' hide Location;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@lazySingleton
class LocationService {
  final Location _location;
  final Geocoding _geocoding;

  LocationService(this._location, this._geocoding);

  Future<bool> requestLocationService() async {
    return await _location.requestService();
  }

  Future<LocationData> fetchUserCurrentLocation() async {
    return await _location.getLocation();
  }

  Future<List<Placemark>> getAddressesFromCoordinates({
    double? lat,
    double? long,
  }) async {
    if (lat == null || long == null) {
      log('Geocoding Error: Coordinates are null');
      return [];
    }

    try {
      return await _geocoding.placemarkFromCoordinates(lat, long);
    } catch (e) {
      log('Geocoding Exception: $e');
      return [];
    }
  }

  String formatAddress(Placemark placemark) {

    return placemark.street ?? '';
  }
}
