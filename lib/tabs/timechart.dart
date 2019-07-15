class Timechart {
  //final String text;
  final int bpm;
  final double hz;
  final double ms;

  const Timechart({
    //this.text,
    this.bpm,
    this.hz,
    this.ms
  });

  factory Timechart.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return null;

    return Timechart(
      //text: json['text'] ?? '[null]',
      bpm: json['bpm'],
      hz: json['hz'],
      ms: json['ms'] ?? 0,
    );
  }

  String text() {
    return "${this.bpm} bpm";
  }
  String toString() {
    return "Timechart-bpm:${this.bpm};hz:${this.hz}:ms:${this.ms}";
  }
}

List<Timechart> timecharts = [
//new Timechart(
//    text: "60 bpm",
//    bpm: 60,
//    hz: 1.0,
//    ms: 1000,
//  ),
];
