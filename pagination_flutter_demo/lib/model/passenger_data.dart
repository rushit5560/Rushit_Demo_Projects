// To parse this JSON data, do
//
//     final passengersData = passengersDataFromJson(jsonString);

import 'dart:convert';

PassengersData passengersDataFromJson(String str) => PassengersData.fromJson(json.decode(str));

String passengersDataToJson(PassengersData data) => json.encode(data.toJson());

class PassengersData {
  PassengersData({
    required this.totalPassengers,
    required this.totalPages,
    required this.data,
  });

  int totalPassengers;
  int totalPages;
  List<Datum> data;

  factory PassengersData.fromJson(Map<String, dynamic> json) => PassengersData(
    totalPassengers: json["totalPassengers"] == null ? 0 : json["totalPassengers"],
    totalPages: json["totalPages"] == null ? 0 : json["totalPages"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))).isEmpty ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPassengers": totalPassengers,
    "totalPages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())).isEmpty ? [] : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.trips,
    required this.airline,
    required this.v,
  });

  String id;
  String name;
  int trips;
  List<Airline> airline;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] == null ? "" : json["_id"],
    name: json["name"] == null ? "" : json["name"],
    trips: json["trips"] == null ? 0 : json["trips"],
    airline: List<Airline>.from(json["airline"].map((x) => Airline.fromJson(x))).isEmpty ? [] : List<Airline>.from(json["airline"].map((x) => Airline.fromJson(x))),
    v: json["__v"] == null ? 0 : json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "trips": trips,
    "airline": List<dynamic>.from(airline.map((x) => x.toJson())),
    "__v": v,
  };
}

class Airline {
  Airline({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.slogan,
    required this.headQuaters,
    required this.website,
    required this.established,
  });

  int id;
  String name;
  String country;
  String logo;
  String slogan;
  String headQuaters;
  String website;
  String established;

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? "" : json["name"],
    country: json["country"] == null ? "" : json["country"],
    logo: json["logo"] == null ? "" : json["logo"],
    slogan: json["slogan"] == null ? "" : json["slogan"],
    headQuaters: json["head_quaters"] == null ? "" : json["head_quaters"],
    website: json["website"] == null ? "" : json["website"],
    established: json["established"] == null ? "" : json["established"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name.isEmpty ? "" : name,
    "country": country.isEmpty ? "" : country,
    "logo": logo.isEmpty ? "" : logo,
    "slogan": slogan.isEmpty ? "" : slogan,
    "head_quaters": headQuaters.isEmpty ? "" : headQuaters,
    "website": website.isEmpty ? "" : website,
    "established": established.isEmpty ? "" : established,
  };
}
