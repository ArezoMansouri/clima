import 'package:clima/components/details_widget.dart';
import 'package:clima/components/error_message.dart';
import 'package:clima/components/loading_widget.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccured = false;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  int code = 0;
  Weather weather = Weather();
  var weatherData;
  String? title, message;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print("Permission denied");
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          print(
              "Permission permanently denied, please provide permission to the app from device settings");
        setState((){
          isDataLoaded=true;
          isErrorOccured=true;
          title="Permission permanently denied";
          message="Please provide permission to the app from device settings";
        });
        } else {
          print("Permission granted");
          updateUI();
        }
      } else {
        print("User denied the request");
        updateUI(cityName: 'herat');
      }
    } else {
      updateUI();
    }
  }

  void updateUI({String? cityName}) async {
    weatherData = null;
    if (cityName == null || cityName=='') {
      if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      setState(() {
        isErrorOccured = true;
        isDataLoaded = true;
        title = 'Location is turned off';
        message =
        'Please enable the location service to see weather condition for you location';
        return;
      });
    }
      weatherData = await weather.getLocationWeather();
    } else {
      weatherData = await weather.getCityWeather(cityName);
    }

    if(weatherData==null){
     setState((){
       title='City not found';
       message='Please make sure you have entered the right city name';
       isDataLoaded=true;
       isErrorOccured=true;
       return;
     });
    }

    code = weatherData['weather'][0]['id'];

    weatherModel = WeatherModel(
      location: weatherData['name'] + ',' + weatherData['sys']['country'],
      description: weatherData['weather'][0]['description'],
      temperture: weatherData['main']['temp'],
      feelsLike: weatherData['main']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['wind']['speed'],
      icon:
          'images/weather_icons/${getIconPrefix(code)}${KWeatherIcons[code.toString()]!['icon']}.svg',
    );

    setState(() {
      isDataLoaded = true;
      isErrorOccured=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: KOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        decoration: KTextFieldDecoration,
                        onSubmitted: (String typeName) {
                       setState(() {
                         isDataLoaded=false;
                         updateUI(cityName: typeName);
                       });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          setState((){
                            isDataLoaded=false;
                            getPermission();
                          });

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white12,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 60,
                          child: Row(
                            children: const [
                              Text(
                                "My Location",
                                style: KTextFieldTextStyle,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.gps_fixed, color: Colors.white60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isErrorOccured
                  ? ErrorMessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                color: KMidLightColor,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                weatherModel!.location!,
                                style: KLocationTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 200,
                            color: KLightColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "${weatherModel!.temperture!.round()}°",
                            style: KTempTextStyle,
                          ),
                          Text(
                            weatherModel!.description!.toUpperCase(),
                            style: KLocationTextStyle,
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: KOverlayColor,
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetailsWidget(
                          title: "FEELS LIKE",
                          value:
                              "${weatherModel != null ? weatherModel!.feelsLike!.round() : 0}°",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        DetailsWidget(
                          title: "HUMIDITY",
                          value:
                              "${weatherModel != null ? weatherModel!.humidity! : 0}%",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        DetailsWidget(
                          title: "WIND",
                          value:
                              "${weatherModel != null ? weatherModel!.wind!.round() : 0}",
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
