import 'package:doorce_style/doorce_style.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';


class DoorLocationPicker extends StatefulWidget {
  final String userAgent;
  final void Function(PickedData) onLocationPicked;
  final bool isEnabled;

  const DoorLocationPicker({
    required this.userAgent,
    required this.onLocationPicked,
    this.isEnabled = true,
  });

  @override
  State<DoorLocationPicker> createState() => _DoorLocationPickerState();
}

class _DoorLocationPickerState extends State<DoorLocationPicker> {
  bool showMap = false;

  ControlsConfiguration controlsConfiguration = ControlsConfiguration(
      zoomButtonsColor: DoorColor.darkEmph,
      zoomButtonsBackgroundColor: DoorColor.lightEmph,
      locationButtonsColor: DoorColor.darkEmph,
      locationButtonBackgroundColor: DoorColor.lightEmph,
      // TODO: add/fix geolocation to web
      showLocationController: false
    );

  MarkerConfiguration markerConfiguration = MarkerConfiguration(
    markerIcon: Icon(Icons.location_pin, color: DoorColor.darkEmph, size: 60),
    animateMarker: true,
  );

  SelectButtonConfiguration selectButtonConfiguration = SelectButtonConfiguration(
    selectLocationButtonText: 'Choose this location',
    selectLocationButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: DoorColor.darkEmph,
      foregroundColor: DoorColor.reverse,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoorButtonPlain(
            showMap ? "Hide map" : "Show map",
            widget.isEnabled
               ? () {
                  setState(() {
                    showMap = !showMap;
                  });
                }
              : null
            ),
          if (showMap)
            SizedBox(
              height: 400,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : MediaQuery.of(context).size.width * 0.5;
                  return SizedBox(
                    width: width,
                    child: FlutterLocationPicker.withConfiguration(
                      userAgent: widget.userAgent,
                      onPicked: widget.onLocationPicked,
                      controlsConfiguration: controlsConfiguration,
                      markerConfiguration: markerConfiguration,
                      selectButtonConfiguration: selectButtonConfiguration,
                    ),
                  );
                },      
              ),
            ),
          ],
        ),
      ],
    );
  }
}