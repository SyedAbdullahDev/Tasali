class bvideomodel {
  String? name;
  String? profilepic;
  String? video;
  String? viduid;
  String? buid;
  bool? islike;
  String? reportdesc;
  bool? report;

  bvideomodel({
    this.name,
    this.islike,
    this.video,
    this.buid,
    this.reportdesc,
    this.report,
    this.viduid,
    this.profilepic,
  });

  factory bvideomodel.fromMap(map) {
    return bvideomodel(
      video: map['video'],
      islike: map['islike'],
      name: map['name'],
      buid: map['buid'],
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
      'buid':buid,
      'reportdesc': reportdesc,
      'report': report,
    };
  }
}
