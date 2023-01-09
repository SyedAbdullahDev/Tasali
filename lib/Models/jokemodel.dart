class jokemodel {
  String? name;
  String? profilepic;
  String? joke;
  String? jokeuid;
  bool? islike;
  bool? report;
  String? reportdesc;

  jokemodel({
    this.name,
    this.islike,
    this.reportdesc,
    this.joke,
    this.profilepic,
    this.jokeuid,
    this.report,
  });

  factory jokemodel.fromMap(map) {
    return jokemodel(
      joke: map['joke'],
      reportdesc: map['reportdesc'],
      jokeuid: map['jokeuid'],
      islike: map['islike'],
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
      'report': report,
      'islike': islike,
      'profilepic': profilepic,
      'joke': joke,
    };
  }
}
