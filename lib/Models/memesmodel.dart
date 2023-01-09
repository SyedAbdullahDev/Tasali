class mememodel {
  String? name;
  String? profilepic;
  String? meme;
  String? memeuid;
  bool? islike;
  bool? report;
  String? reportdesc;
  mememodel({
    this.name,
    this.reportdesc,
    this.islike,
    this.meme,
    this.report,
    this.profilepic,
    this.memeuid,
  });

  factory mememodel.fromMap(map) {
    return mememodel(
      meme: map['meme'],
      report: map['report'],
      reportdesc: map['reportdesc'],
      memeuid: map['memeuid'],
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
      'memeuid': memeuid,
      'reportdesc': reportdesc,
      'islike': islike,
      'meme': meme,
    };
  }
}
