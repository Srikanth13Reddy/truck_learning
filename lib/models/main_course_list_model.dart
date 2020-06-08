class MainCourseListModel
{
  String _courseId;
  String _courseName;
  String _courseCategory;
  String _courseDescription;
  String _vehicleTypeId;
  String _courseSortOrder;
  String _createdDate;
  String _vehicleType;
  String _userId;
  String _courseStartDate;
  String _courseEndDate;
  String _courseStatus;
  String _mediaContent;

  MainCourseListModel(this._courseId, this._courseName, this._courseCategory,
      this._courseDescription, this._vehicleTypeId, this._courseSortOrder,
      this._createdDate, this._vehicleType, this._userId, this._courseStartDate,
      this._courseEndDate, this._courseStatus, this._mediaContent);

  String get mediaContent => _mediaContent;

  set mediaContent(String value) {
    _mediaContent = value;
  }

  String get courseStatus => _courseStatus;

  set courseStatus(String value) {
    _courseStatus = value;
  }

  String get courseEndDate => _courseEndDate;

  set courseEndDate(String value) {
    _courseEndDate = value;
  }

  String get courseStartDate => _courseStartDate;

  set courseStartDate(String value) {
    _courseStartDate = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get vehicleType => _vehicleType;

  set vehicleType(String value) {
    _vehicleType = value;
  }

  String get createdDate => _createdDate;

  set createdDate(String value) {
    _createdDate = value;
  }

  String get courseSortOrder => _courseSortOrder;

  set courseSortOrder(String value) {
    _courseSortOrder = value;
  }

  String get vehicleTypeId => _vehicleTypeId;

  set vehicleTypeId(String value) {
    _vehicleTypeId = value;
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


}