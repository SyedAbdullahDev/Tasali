class videomodel {
  String? name;
  String? profilepic;
  String? video;
  String? viduid;
  bool? islike;
  String? reportdesc;
  bool? report;

  videomodel({
    this.name,
    this.islike,
    this.video,
    this.reportdesc,
    this.report,
    this.viduid,
    this.profilepic,
  });

  factory videomodel.fromMap(map) {
    return videomodel(
      video: map['video'],
      islike: map['islike'],
      name: map['name'],
      reportdesc: map['reportdesc'],
      profilepic: map['profilepic'],
      viduid: map['viduid'],
      report: map['report'],
    );
  }

//sending
  Map<String, dynamic> tomap() {
    return {
      'name': name,
      'viduid': viduid,
      'islike': islike,
      'profilepic': profilepic,
      'video': video,
      'reportdesc': reportdesc,
      'report': report,
    };
  }
}
