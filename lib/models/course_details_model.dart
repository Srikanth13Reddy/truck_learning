class CourseDetailsModel
{
  String _chapterId;
  String _chapterName;
  String _chapterDescription;
  String _chapterOrder;
  String _totalLesson;
  String _completedLesson;
  String _mediaContent;
  String _countWiseStatus;
  String _status;

  String get chapterId => _chapterId;

  set chapterId(String value) {
    _chapterId = value;
  }

  String get chapterName => _chapterName;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get countWiseStatus => _countWiseStatus;

  set countWiseStatus(String value) {
    _countWiseStatus = value;
  }

  String get mediaContent => _mediaContent;

  set mediaContent(String value) {
    _mediaContent = value;
  }

  String get completedLesson => _completedLesson;

  set completedLesson(String value) {
    _completedLesson = value;
  }

  String get totalLesson => _totalLesson;

  set totalLesson(String value) {
    _totalLesson = value;
  }

  String get chapterOrder => _chapterOrder;

  set chapterOrder(String value) {
    _chapterOrder = value;
  }

  String get chapterDescription => _chapterDescription;

  set chapterDescription(String value) {
    _chapterDescription = value;
  }

  set chapterName(String value) {
    _chapterName = value;
  }


}