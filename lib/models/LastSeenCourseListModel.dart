class LastSeenCourseListModel
{
  String _courseDetailId;
  String _userId;
  String _courseId;
  String _courseName;
  String _courseCategory;
  String _courseDescription;
  String _courseStartDate;
  String _courseEndDate;
  String _courseURL;

  LastSeenCourseListModel(this._courseDetailId, this._userId, this._courseId,
      this._courseName, this._courseCategory, this._courseDescription,
      this._courseStartDate, this._courseEndDate,this._courseURL);


  String get courseURL => _courseURL;

  set courseURL(String value) {
    _courseURL = value;
  }

  String get courseEndDate => _courseEndDate;

  set courseEndDate(String value) {
    _courseEndDate = value;
  }

  String get courseStartDate => _courseStartDate;

  set courseStartDate(String value) {
    _courseStartDate = value;
  }

  String get courseDescription => _courseDescription;

  set courseDescription(String value) {
    _courseDescription = value;
  }

  String get courseCategory => _courseCategory;

  set courseCategory(String value) {
    _courseCategory = value;
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  String get courseId => _courseId;

  set courseId(String value) {
    _courseId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get courseDetailId => _courseDetailId;

  set courseDetailId(String value) {
    _courseDetailId = value;
  }


}