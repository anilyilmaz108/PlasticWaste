class SampleModel{
  final String? title;
  final String? subtitle;
  final String? files;
  final double lat;
  final double lng;
  final String? datetime;
  final String? typ;


  SampleModel({this.title, this.subtitle, this.files, required this.lat, required this.lng, this.datetime, this.typ});

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      title: json['title'],
      subtitle: json['subtitle'],
      files: json['files'],
      lat: json['lat'],
      lng: json['lng'],
      datetime: json['datetime'],
      typ: json['typ']
    );
  }
}