class bjokemodel {
  String? name;
  String? profilepic;
  String? joke;
  String? jokeuid;
  String? buid;
  bool? islike;
  bool? report;
  String? reportdesc;

  bjokemodel({
    this.name,
    this.islike,
    this.buid,
    this.reportdesc,
    this.joke,
    this.profilepic,
    this.jokeuid,
    this.report,
  });

  factory bjokemodel.fromMap(map) {
    return bjokemodel(
      joke: map['joke'],
      reportdesc: map['reportdesc'],
      jokeuid: map['jokeuid'],
      islike: map['islike'],
      buid: map['buid'],
      report: map['report'],
      name: map['name'],
      profilepic: map['profilepic'],
    );
  }

//sending
  Map<String, dynamic> tomap() {
    return {
      'name': name,
      'jokeuid': jokeuid,
      'reportdesc': reportdesc,
      'buid': buid,
      'report': report,
      'islike': islike,
      'profilepic': profilepic,
      'joke': joke,
    };
  }
}
