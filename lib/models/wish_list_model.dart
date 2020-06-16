class WishListModel
{
  String  _courseId;
  String  _courseName;
  String  _courseDescription;
  String  _createdDate;
  String  _courseURL;
  String  _chapterDetails;

  String get courseId => _courseId;

  set courseId(String value) {
    _courseId = value;
  }

  String get courseName => _courseName;

  String get chapterDetails => _chapterDetails;

  set chapterDetails(String value) {
    _chapterDetails = value;
  }

  String get courseURL => _courseURL;

  set courseURL(String value) {
    _courseURL = value;
  }

  String get createdDate => _createdDate;

  set createdDate(String value) {
    _createdDate = value;
  }

  String get courseDescription => _courseDescription;

  set courseDescription(String value) {
    _courseDescription = value;
  }

  set courseName(String value) {
    _courseName = value;
  }


}