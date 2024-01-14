import 'dart:convert';

class ResponseData {
  String message = '';
  String polyline = '';
  double durationEstimate;
  double distance;
  int leftPoints;
  String address;
  String nextPointId;

  ResponseData(
      {this.message,
      this.polyline,
      this.distance,
      this.durationEstimate,
      this.leftPoints,
      this.address,
      this.nextPointId
      });

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['message'] = message;
    map['polyline'] = polyline;
    map['duration_estimate'] = durationEstimate.toString();
    map['distance'] = distance.toString();
    map['left_points'] = leftPoints.toString();
    map['address'] = address;
    map['next_point_id'] = nextPointId;

    return map;
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
        message: json['message'] as String,
        polyline: json['polyline'] as String,
        distance: (json['distance'] as num).toDouble(),
        durationEstimate: (json['duration_estimate'] as num).toDouble(),
        leftPoints: (json['left_points'] as num).toInt(),
        address: json['address'] as String,
        nextPointId: json['next_point_id'] as String
    );

  }
}
