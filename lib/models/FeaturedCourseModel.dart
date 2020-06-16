

class FeaturedCourseModel
{
  String _courseId;
  String _courseName;
  String _courseCategory;
  String _courseDescription;
  String _mediaContentDetails;

  FeaturedCourseModel(this._courseId, this._courseName, this._courseCategory,
      this._courseDescription, this._mediaContentDetails);

  String get mediaContentDetails => _mediaContentDetails;

  set mediaContentDetails(String value) {
    _mediaContentDetails = value;
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
