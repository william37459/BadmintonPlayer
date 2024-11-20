class Class {
  int classID;
  String className;
  int sortIndex;

  Class({
    required this.classID,
    required this.className,
    required this.sortIndex,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      classID: json['classID'],
      className: json['className'],
      sortIndex: json['sortIndex'],
    );
  }
}
