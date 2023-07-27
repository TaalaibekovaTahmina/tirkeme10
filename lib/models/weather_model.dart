class WeatherModel {
  WeatherModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.countri,
    required this.city,
  });

  final int id;
  final String main;
  final String description;
  final String icon;
  final String temp;
  final String countri;
  final String city;
}
