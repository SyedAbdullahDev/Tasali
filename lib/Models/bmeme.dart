class bmememodel {
  String? name;
  String? profilepic;
  String? meme;
  String? memeuid;
  String? buid;

  bool? islike;
  bool? report;
  String? reportdesc;
  bmememodel({
    this.name,
    this.reportdesc,
    this.islike,
    this.meme,
    this.buid,
    this.report,
    this.profilepic,
    this.memeuid,
  });

  factory bmememodel.fromMap(map) {
    return bmememodel(
      meme: map['meme'],
      report: map['report'],
      reportdesc: map['reportdesc'],
      memeuid: map['memeuid'],
      buid: map['buid'],
      name: map['name'],
      islike: map['islike'],
      profilepic: map['profilepic'],
    );
  }

//sending
  Map<String, dynamic> tomap() {
    return {
      'name': name,
      'report': report,
      'profilepic': profilepic,
      'buid': buid,
      'memeuid': memeuid,
      'reportdesc': reportdesc,
      'islike': islike,
      'meme': meme,
    };
  }
}
