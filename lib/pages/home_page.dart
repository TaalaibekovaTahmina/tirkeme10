import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tirkeme10/components/custom_icon_button.dart';
import 'package:tirkeme10/constands/api_const.dart';
import 'package:tirkeme10/constands/app_colors.dart';
import 'package:tirkeme10/constands/app_text.dart';
import 'package:tirkeme10/constands/app_text_styles.dart';
import 'package:tirkeme10/models/weather_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<WeatherModel?> fetchData() async {
    final dio = Dio();
    final response = await dio.get(ApiConst.api);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final weatherModel = WeatherModel(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        temp: response.data['main']['temp'],
        countri: response.data['sys']['country'],
        city: response.data['name'],
      );
      // setState(() {});
      return weatherModel;
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(
          AppText.appBar,
          style: AppTextStyles.appBar,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/foto.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(icon: Icons.near_me),
                CustomIconButton(icon: Icons.location_city),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
