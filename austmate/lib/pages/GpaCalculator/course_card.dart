import 'package:flutter/material.dart';
import 'course.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onDeleted;
  final ValueChanged<String> onGradeChanged;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<double> onCreditsChanged;

  const CourseCard({
    super.key,
    required this.course,
    required this.onDeleted,
    required this.onGradeChanged,
    required this.onCodeChanged,
    required this.onTitleChanged,
    required this.onCreditsChanged,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late String selectedGrade;
  late double selectedCredits;
  late TextEditingController _codeController;
  late TextEditingController _titleController;

  final List<String> grades = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'D',
    'F',
  ];

  final List<double> creditOptions = [4.0, 3.0, 2.0, 1.5, 0.75];

  @override
  void initState() {
    super.initState();
    selectedGrade = widget.course.grade;
    selectedCredits = widget.course.credits;
    _codeController = TextEditingController(text: widget.course.code);
    _titleController = TextEditingController(text: widget.course.title);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course.grade != widget.course.grade) {
      selectedGrade = widget.course.grade;
    }
    if (oldWidget.course.credits != widget.course.credits) {
      selectedCredits = widget.course.credits;
    }
    if (oldWidget.course.code != widget.course.code &&
        _codeController.text != widget.course.code) {
      _codeController.text = widget.course.code;
    }
    if (oldWidget.course.title != widget.course.title &&
        _titleController.text != widget.course.title) {
      _titleController.text = widget.course.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE76C6C).withOpacity(0.3),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  onChanged: widget.onCodeChanged,
                  style: const TextStyle(
                    color: Color(0xFFE76C6C),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Course Code',
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onDeleted,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE76C6C),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _titleController,
            onChanged: widget.onTitleChanged,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: 'Course Title',
              hintStyle: TextStyle(color: Colors.black26),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Credits',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 36,
                      width: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDECEC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            value: creditOptions.contains(selectedCredits)
                                ? selectedCredits
                                : creditOptions[1],
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFE76C6C),
                              size: 20,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFE76C6C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            isExpanded: true,
                            items: creditOptions.map((credit) {
                              return DropdownMenuItem<double>(
                                value: credit,
                                child: Center(
                                  child: Text(
                                    credit.toString().replaceAll(
                                      RegExp(r'\.0$'),
                                      '',
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFFE76C6C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCredits = value;
                                });
                                widget.onCreditsChanged(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grade (Letter)',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 36,
                      width: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDECEC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGrade,
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFE76C6C),
                              size: 20,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFE76C6C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            isExpanded: true,
                            items: grades.map((grade) {
                              return DropdownMenuItem<String>(
                                value: grade,
                                child: Center(
                                  child: Text(
                                    grade,
                                    style: const TextStyle(
                                      color: Color(0xFFE76C6C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedGrade = value;
                                });
                                widget.onGradeChanged(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}