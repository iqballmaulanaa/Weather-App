import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'constant.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  late num temp;
  late num press;
  late num hum;
  late num cover;
  String cityname = '';

  TextEditingController controller = TextEditingController();

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);
    if (p != null) {
      print('Lat: ${p.latitude}, Long: ${p.longitude}');
      getCurrentCityWeather(p);
      getCityWeather('malang');
    } else {
      print('Data unavailable');
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=${cityname}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  updateUI(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityname = 'Not available';
      } else {
        temp = decodeData['main']['temp'] - 273;
        press = decodeData['main']['pressure'];
        hum = decodeData['main']['humidity'];
        cover = decodeData['clouds']['all'];
        cityname = decodeData['name'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 125, 132, 196),
            Color.fromARGB(255, 158, 83, 154),
            Color.fromARGB(255, 77, 153, 110),
          ], begin: Alignment.bottomLeft, end: Alignment.topRight),
        ),
        child: Visibility(
          visible: isLoaded,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.09,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    onFieldSubmitted: (String s) {
                      setState(() {
                        cityname = s;
                        getCityWeather(s);
                        isLoaded = false;
                        controller.clear();
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search city',
                      hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      cityname,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage('images/thermometer.png'),
                      width: MediaQuery.of(context).size.width * 0.09,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Temperature: ${temp?.toInt()} C',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage('images/barometer.png'),
                      width: MediaQuery.of(context).size.width * 0.09,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Pressure: ${press?.toInt()} hPa',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage('images/humidity.png'),
                      width: MediaQuery.of(context).size.width * 0.09,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Humidity: ${hum?.toInt()}%',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage('images/cloud cover.png'),
                      width: MediaQuery.of(context).size.width * 0.09,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Cloude cover: ${cover?.toInt()}%',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    ));
  }
}
