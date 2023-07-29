import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tirkeme10/constands/api_const.dart';
import 'package:tirkeme10/models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;

  Future<WeatherModel?> fetchData() async {
    final dio = Dio();
    final response = await dio.get(ApiConst.api);
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
      // setState(() {});
      return weatherModel;
    }
  }

  // @override
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (ctx, sn) {
            if (sn.hasData) {
              return Column(
                children: [
                  Text(sn.data!.id.toString()),
                  Text(sn.data!.main),
                  Text(sn.data!.description),
                  Text(sn.data!.icon),
                  Text('${sn.data!.temp}'),
                  Text(sn.data!.country!),
                  Text(sn.data!.city ?? 'Salam'),
                ],
              );
            } else if (sn.hasError) {
              return Text(sn.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
