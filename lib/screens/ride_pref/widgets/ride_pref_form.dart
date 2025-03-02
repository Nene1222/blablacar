import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../widgets/inputs/locations_picker.dart';

/// A Ride Preference Form to select:
///   - A departure location
///   - An arrival location
///   - A date
///   - A number of persons
class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure; // Changed to nullable
  DateTime departureDate = DateTime.now();
  Location? arrival; // Changed to nullable
  int requestedPersons = 1; // Default to 1 person

  @override
  void initState() {
    super.initState();
    // Initialize with provided RidePref if available
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedPersons = widget.initRidePref!.requestedSeats; // Assuming this maps to persons
    }
  }

  // Get departure label
  String get departureLabel => departure?.name ?? "Leaving from";

  // Get arrival label
  String get arrivalLabel => arrival?.name ?? "Going to";

  // Select Departure Location
  void _selectDeparture() {
    showDialog(
      context: context,
      builder: (context) {
        return BlaLocationPicker(
          initLocation: departure,
          onLocationSelected: (selectedLocation) {
            setState(() {
              departure = selectedLocation; // Use previous if null
            });
          },
        );
      },
    );
  }

  // Select Arrival Location
  void _selectArrival() {
    showDialog(
      context: context,
      builder: (context) {
        return BlaLocationPicker(
          initLocation: arrival,
          onLocationSelected: (selectedLocation) {
            setState(() {
              arrival = selectedLocation; // Use previous if null
            });
          },
        );
      },
    );
  }

  // Select Departure Date
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        departureDate = pickedDate;
      });
    }
  }

  // Show Persons Dialog
  void _showPersonsDialog() {
    int tempPersons = requestedPersons;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Number of persons to book',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$tempPersons',
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          if (tempPersons > 1) {
                            setState(() {
                              tempPersons--;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (tempPersons < 10) {
                            setState(() {
                              tempPersons++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  requestedPersons = tempPersons; // Update the main variable
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  // Swap departure and arrival locations
  void _swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  // Build the widgets
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BlaSpacings.m),
      child: Container(
        decoration: BoxDecoration(
          color: BlaColors.white,
          borderRadius: BorderRadius.circular(BlaSpacings.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(BlaSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Departure Location Selection
            GestureDetector(
              onTap: _selectDeparture,
              child: _buildLocationRow(departureLabel, Icons.location_on),
            ),
            const SizedBox(height: BlaSpacings.s),
            // Arrival Location Selection
            GestureDetector(
              onTap: _selectArrival,
              child: _buildLocationRow(arrivalLabel, Icons.location_on),
            ),
            const SizedBox(height: BlaSpacings.s),
            // Departure Date Selection
            GestureDetector(
              onTap: _selectDate,
              child: _buildDateRow(),
            ),
            const SizedBox(height: BlaSpacings.s),
            // Number of Persons Selection
            GestureDetector(
              onTap: _showPersonsDialog,
              child: _buildPersonsRow(),
            ),
            const SizedBox(height: BlaSpacings.s),
            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Helper method to build location row
  Widget _buildLocationRow(String locationName, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(BlaSpacings.s),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BlaColors.greyLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: BlaColors.primary),
              SizedBox(width: 8),
              Text(locationName, style: BlaTextStyles.label),
            ],
          ),
          IconButton(
            icon: Icon(Icons.swap_vert, color: BlaColors.primary),
            onPressed: _swapLocations,
            tooltip: 'Swap locations',
          ),
        ],
      ),
    );
  }

  // Helper method to build date row
  Widget _buildDateRow() {
    return Container(
      padding: const EdgeInsets.all(BlaSpacings.s),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BlaColors.greyLight),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: BlaColors.primary),
          SizedBox(width: 8),
          Text(DateFormat('EEE d MMM').format(departureDate), style: BlaTextStyles.label),
        ],
      ),
    );
  }

  // Helper method to build persons row
  Widget _buildPersonsRow() {
    return Container(
      padding: const EdgeInsets.all(BlaSpacings.s),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BlaColors.greyLight),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.group, color: BlaColors.primary),
          SizedBox(width: 8),
          Text('$requestedPersons', style: BlaTextStyles.label),
        ],
      ),
    );
  }

  // Helper method to build submit button
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print('Searching rides from ${departure?.name ?? "Leaving from"} to ${arrival?.name ?? "Going to"} on ${departureDate.toLocal()} with $requestedPersons persons.');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: BlaColors.primary,
          padding: const EdgeInsets.all(BlaSpacings.l),
          textStyle: BlaTextStyles.button,
        ),
        child: Text('Search', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}