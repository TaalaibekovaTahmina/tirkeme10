import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tirkeme10/components/custom_icon_button.dart';
import 'package:tirkeme10/constands/api_const.dart';
import 'package:tirkeme10/constands/app_colors.dart';
import 'package:tirkeme10/constands/app_text.dart';
import 'package:tirkeme10/models/weather_model.dart';

import '../constands/app_text_styles.dart';

List<String> cities = [
  'Bishkek',
  'Naryn',
  'Ysyk-Kol',
  'Talas',
  'Osh',
  'Jalal-Abad',
  'Batken',
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;

  Future<void> wetherLocation() async {
    setState(() {
      weatherModel = null;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final response = await dio.get(
          ApiConst.getLocator(
            lat: position.latitude,
            lon: position.longitude,
          ),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          weatherModel = WeatherModel(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            temp: response.data['current']['temp'],
            country: response.data['timezone'],
            city: response.data['timezone'],
          );
        }
        setState(() {});
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio.get(
        ApiConst.getLocator(
          lat: position.latitude,
          lon: position.longitude,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        weatherModel = WeatherModel(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          temp: response.data['current']['temp'],
          country: response.data['timezone'],
          city: response.data['timezone'],
        );
      }
      setState(() {});
    }
  }

  Future<void> weatherName({String? cityName}) async {
    final dio = Dio();
    final response =
        await dio.get(ApiConst.api(cityName: cityName ?? 'Bishkek'));
    if (response.statusCode == 200 || response.statusCode == 201) {
      weatherModel = WeatherModel(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        temp: response.data['main']['temp'],
        country: response.data['sys']['country'],
        city: response.data['name'],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    weatherName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(AppText.appBar, style: AppTextStyles.appBar),
      ),
      body: weatherModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/surot.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconsButton(
                        onPressed: () async {
                          wetherLocation();
                        },
                        icon: Icons.near_me,
                      ),
                      CustomIconsButton(
                        onPressed: () {
                          showBottomSheet();
                        },
                        icon: Icons.location_city,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          '${temp(weatherModel!.temp)}',
                          style: const TextStyle(
                            fontSize: 96,
                            color: Colors.amber,
                          ),
                        ),
                        Image.network(
                          ApiConst.getIcon(weatherModel!.icon, 4),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          weatherModel!.description.replaceAll(
                            ' ',
                            '\n',
                          ),
                          style: const TextStyle(
                            fontSize: 60,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FittedBox(
                          child: Text(
                            weatherModel!.city!,
                            style: const TextStyle(
                              fontSize: 65,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  int temp(double? temp) {
    return (temp! - 273.15).toInt();
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.white,
            ),
            color: AppColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          // color: Colors.amber,
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      weatherModel = null;
                    });
                    weatherName(cityName: city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
