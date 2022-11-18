import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';

class AutoSearchPlacesPopUp extends StatefulWidget {

  AutoSearchPlacesPopUp();

  @override
  State<AutoSearchPlacesPopUp> createState() => _AutoSearchPlacesPopUpState();
}

class _AutoSearchPlacesPopUpState extends State<AutoSearchPlacesPopUp> {
  TextEditingController _controller = new TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placeList = [];
  var _placeId = '';
  String placeApikey = "AIzaSyDHiy6LnesFKtAQwz7wTi2BY0cY6oidILE";

  var _streetNumber;
  var _street;
  var _city;
  var _zipCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
      _placeId;
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestions(_controller.text);
  }

  Future<void> getSuggestions(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$input&key=$placeApikey';

    var response = await http.get(Uri.parse(request));
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body.toString())['predictions'];
        _placeId =
            jsonDecode(response.body.toString())['predictions'][0]['place_id'];
        print("Place Id : " + _placeId.toString());
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$placeApikey&sessiontoken=$_sessionToken';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
            print("zipcode : " + place.zipCode.toString());
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 70.0, maxHeight: 600.0, maxWidth: 350.0, minWidth: 200),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Seek your location here",
                      // focusColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.map, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          _controller.clear();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: ThemeApp.textFieldBorderColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.innerTextFieldErrorColor,
                              width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _placeList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final result = _placeList[index];

                          // _controller.text =   _placeList[index]["description"] ;
                          final placeDetails =
                              await PlaceApiProvider(_sessionToken)
                                  .getPlaceDetailFromId(
                                      _placeList[index]["place_id"]);
                          setState(() {
                            _controller.text = result['description'];
                            _streetNumber = placeDetails.streetNumber;
                            _street = placeDetails.street;
                            _city = placeDetails.city;
                            _zipCode = placeDetails.zipCode;
                            setState(() {
                              Prefs().setToken(StringConstant.pinCodePref,
                                  placeDetails.zipCode.toString());

                              Prefs().setToken(StringConstant.addressPref,
                                  result['description'] + "-"+placeDetails.zipCode);
                            });

                            print("response zipcode $_zipCode");
                          });
                          StringConstant.placesFromCurrentLocation =
                              (await Prefs()
                                  .getToken(StringConstant.pinCodePref))!;

                          print(
                              "placesFromCurrentLocation pref...${StringConstant.placesFromCurrentLocation.toString()}");
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(),), (route) => false);

                        },
                        child: ListTile(
                          title: Text(_placeList[index]["description"]),
                        ),
                      );
                    },
                  ),
                ),
                // listOfShopByCategories()
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

//////////
class Autosearch extends StatefulWidget {
  const Autosearch({Key? key}) : super(key: key);

  @override
  State<Autosearch> createState() => _AutosearchState();
}

class _AutosearchState extends State<Autosearch> {
  TextEditingController _controller = new TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placeList = [];
  var _placeId = '';
  String placeApikey = "AIzaSyDHiy6LnesFKtAQwz7wTi2BY0cY6oidILE";

  var _streetNumber;
  var _street;
  var _city;
  var _zipCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
      _placeId;
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestions(_controller.text);
  }

  Future<void> getSuggestions(String input) async {
    print("response :  .....");

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$input&key=$placeApikey';

    var response = await http.get(Uri.parse(request));
    print("response :" + response.body);

    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body.toString())['predictions'];
        _placeId =
            jsonDecode(response.body.toString())['predictions'][0]['place_id'];
        print("Place Id : " + _placeId.toString());
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$placeApikey&sessiontoken=$_sessionToken';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode != 200 ||
        json.decode(response.body)['status'] == "REQUEST_DENIED") {
      print("result.........." + response.body);
    }
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
            print("zipcode : " + place.zipCode.toString());
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Google Map Search places Api',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Seek your location here",
                  // focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.map, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.height * 0.020),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.textFieldBorderColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ThemeApp.textFieldBorderColor, width: 1)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ThemeApp.textFieldBorderColor, width: 1)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ThemeApp.innerTextFieldErrorColor, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ThemeApp.textFieldBorderColor, width: 1)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final result = _placeList[index];

                      // _controller.text =   _placeList[index]["description"] ;
                      final placeDetails = await PlaceApiProvider(_sessionToken)
                          .getPlaceDetailFromId(_placeList[index]["place_id"]);
                      setState(() {
                        _controller.text = result['description'];
                        _streetNumber = placeDetails.streetNumber;
                        _street = placeDetails.street;
                        _city = placeDetails.city;
                        _zipCode = placeDetails.zipCode;
                        print("response zipcode $_zipCode");
                      });
                    },
                    child: ListTile(
                      title: Text(_placeList[index]["description"]),
                    ),
                  );
                },
              ),
            ),
            // listOfShopByCategories()
          ],
        ),
      ),
    );
  }

  Widget listOfShopByCategories() {
    return FutureBuilder<Place>(
        future: getPlaceDetailFromId(_placeId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height * .13,
                  child: Text(snapshot.data!.zipCode.toString()),
                )
              : new Center(child: new CircularProgressIndicator());
        });
  }
}

class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String apiKey = 'AIzaSyDHiy6LnesFKtAQwz7wTi2BY0cY6oidILE';

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list

        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
