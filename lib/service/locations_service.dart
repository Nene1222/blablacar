import 'package:week_3_blabla_project/model/ride/locations.dart';

import '../dummy_data/dummy_data.dart';

////
///   This service handles:
///   - The list of available rides
///
class LocationsService {

  static const List<Location> availableLocations = fakeLocations;   // TODO for now fake data
 
}



















// import 'package:flutter/material.dart';
// import 'package:week_3_blabla_project/main.dart';
// import 'package:week_3_blabla_project/model/ride/locations.dart';

// import '../dummy_data/dummy_data.dart';

// ////
// ///   This service handles:
// ///   - The list of available rides
// ///
// ///

// class Location {
//   final String name;
//   final String description;

//   Location({required this.name, required this.description});   //put {} from the class of it
// }

// List<Location> fakeLocations = [
//   Location(name: 'Location A', description: 'Description A'),
//   Location(name: 'Location B', description: 'Description B'),
// ];

// class LocationsService {
//   static List<Location> availableLocations = fakeLocations; // Static list of available locations

//   // Method to retrieve all available locations
//   List<Location> getLocations() {
//     return availableLocations; // Returns the list of available locations
//   }

//   // Simulates fetching real locations with a delay
//   Future<List<Location>> fetchRealLocations() async {
//     await Future.delayed(Duration(seconds: 2)); // Simulating delay
//     return availableLocations; // Returns the available locations
//   }
// }