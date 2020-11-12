import 'package:latlong/latlong.dart';
import 'package:pizza_user_app/helper/helper.dart';

double countDistance(double lat, double lng, double userLat, double userLng) {

  return Distance().as(
    LengthUnit.Kilometer,
    LatLng(lat, lng),

    LatLng(userLat, userLng),
  );
}