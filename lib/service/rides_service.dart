import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart';

import '../dummy_data/dummy_data.dart';
import '../model/ride/ride.dart';

////
///   This service handles:
///   - The list of available rides
///
class RidesService {
  static List<Ride> availableRides = fakeRides; // Using dummy data

  static List<Ride> getRidesFor(RidePref preferences) {
    return availableRides.where((ride) => 
      ride.departureLocation == preferences.departure &&
      ride.arrivalLocation == preferences.arrival
    ).toList();
  }
}