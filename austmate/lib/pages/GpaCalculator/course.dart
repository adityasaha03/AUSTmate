class Course {
  String code;
  String title;
  double credits;
  String grade;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.grade,
  });

  static double getGradePoints(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 3.75;
      case 'A-':
        return 3.50;
      case 'B+':
        return 3.25;
      case 'B':
        return 3.00;
      case 'B-':
        return 2.75;
      case 'C+':
        return 2.50;
      case 'C':
        return 2.25;
      case 'D':
        return 2.00;
      case 'F':
        return 0.00;
      default:
        return 0.00;
    }
  }

  double get gradePoints => getGradePoints(grade);
}
