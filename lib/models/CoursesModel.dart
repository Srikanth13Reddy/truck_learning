class CoursesModel
{
  int _courseId;
  String _courseName;
  String _courseDescription;
  String _courseURL;
  String _createdDate;
  int _totalChapter;
  int _totalLesson;

  CoursesModel();

  int get totalLesson => _totalLesson;

  set totalLesson(int value) {
    _totalLesson = value;
  }

  int get totalChapter => _totalChapter;

  set totalChapter(int value) {
    _totalChapter = value;
  }

  String get createdDate => _createdDate;

  set createdDate(String value) {
    _createdDate = value;
  }

  String get courseURL => _courseURL;

  set courseURL(String value) {
    _courseURL = value;
  }

  String get courseDescription => _courseDescription;

  set courseDescription(String value) {
    _courseDescription = value;
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  int get courseId => _courseId;

  set courseId(int value) {
    _courseId = value;
  }


}