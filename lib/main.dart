import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const Mausam());
}

class Mausam extends StatefulWidget {
  const Mausam({Key? key}) : super(key: key);

  @override
  _MausamState createState() => _MausamState();
}

class _MausamState extends State<Mausam> {
  final myTextField = TextEditingController();
  String city = '' ;
  String icon = '01d';
  String description = 'black';
  var temperature ;
  String location = 'Nagpur';
  int woeid = 44418;
  String weather = 'CLEAR SKY';
  String locationApiUrl = 'api.openweathermap.org';
  String locationApiUrlTwo ='/data/2.5/weather';
  String errorMessage = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSearch(location);
  }

  fetchSearch (String input) async {
    try{
      var paramsLoc = {
        "q": input,
        'appid' :'your id'
      };
      var fetchSearchUrl = Uri.https(locationApiUrl, locationApiUrlTwo, paramsLoc);
      var res = await http.get(fetchSearchUrl);
      var result = jsonDecode(res.body);

      setState(() {
        var weatherdata = result["weather"][0];
        description = weatherdata["description"].replaceAll(' ','').toLowerCase();
        weather = weatherdata["description"].toUpperCase();
        icon = weatherdata["icon"];
        var temperaturedata = result["main"];
        var kelvintemperature = temperaturedata["temp"];
        var mytemperature = kelvintemperature - 273.15;
        temperature = mytemperature.round();
        location = result["name"];
        errorMessage ='';
      });

    }
    catch(error){
      setState(() {
        errorMessage = "Sorry, we don't have data about this city. Try another one.";
      });
    }
  }


  setCity(input) async{
    city = myTextField.text;
    await fetchSearch(city);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner :false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$description.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: temperature == null ? const Center(child: CircularProgressIndicator()): Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Center(
                    child: Image.network('http://openweathermap.org/img/wn/$icon@2x.png'),
                  ),
                  Center(
                    child: Text(temperature.toString() + ' °C' ,
                    style: const TextStyle(color: Colors.white , fontSize: 60.0),
                    ),
                  ),
                  Center(
                    child: Text(location ,
                        style: const TextStyle(color:Colors.white , fontSize: 40) ),
                  ),
                  Center(
                    child: Text(weather ,
                        style: const TextStyle(color:Colors.white , fontSize: 15) ),
                  ),
                ],
              ),
              Column(
                children:  <Widget>[
                  SizedBox(
                    width: 300,
                      child: Column(
                        children: [
                          Center(
                            child: TextField(
                              onSubmitted: (String input){
                                setCity(input);
                              },
                              style: const TextStyle(color: Colors.white , fontSize: 25),
                              decoration: const InputDecoration(
                                hintText: 'Search another location.......',
                                hintStyle: TextStyle( color: Colors.white , fontSize: 18.0),
                                prefixIcon: Icon(Icons.search , color: Colors.white),
                              ),
                              controller: myTextField,
                            ),

                          ),
                          // ElevatedButton(onPressed: setCity, child: const Text('Search')),
                          Text(errorMessage ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

