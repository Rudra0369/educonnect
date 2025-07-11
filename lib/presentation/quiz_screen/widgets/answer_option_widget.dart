import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnswerOptionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final dynamic selectedAnswer;
  final Function(dynamic) onAnswerSelected;

  const AnswerOptionWidget({
    Key? key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  State<AnswerOptionWidget> createState() => _AnswerOptionWidgetState();
}

class _AnswerOptionWidgetState extends State<AnswerOptionWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.question['type'] == 'fill_blank' &&
              widget.selectedAnswer != null
          ? widget.selectedAnswer.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildMultipleChoiceOptions() {
    final options = widget.question['options'] as List;

    return Column(
      children: options.map<Widget>((option) {
        final isSelected = widget.selectedAnswer == option['id'];

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () => widget.onAnswerSelected(option['id']),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      option['text'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseOptions() {
    final options = widget.question['options'] as List;

    return Row(
      children: options.map<Widget>((option) {
        final isSelected = widget.selectedAnswer == option['id'];
        final isTrue = option['id'] == 'true';

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
                right: isTrue ? 2.w : 0, left: isTrue ? 0 : 2.w),
            child: InkWell(
              onTap: () => widget.onAnswerSelected(option['id']),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isTrue
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error)
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? (isTrue
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.error)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: isTrue ? 'check_circle' : 'cancel',
                      color: isSelected
                          ? (isTrue
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error)
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      option['text'] ?? '',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? (isTrue
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.error)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleSelectOptions() {
    final options = widget.question['options'] as List;
    final selectedOptions = widget.selectedAnswer as List? ?? [];

    return Column(
      children: options.map<Widget>((option) {
        final isSelected = selectedOptions.contains(option['id']);

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              List<String> newSelection = List<String>.from(selectedOptions);
              if (isSelected) {
                newSelection.remove(option['id']);
              } else {
                newSelection.add(option['id']);
              }
              widget.onAnswerSelected(newSelection);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      option['text'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillBlankInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type your answer:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _textController,
            onChanged: (value) => widget.onAnswerSelected(value),
            decoration: InputDecoration(
              hintText: 'Enter your answer here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(3.w),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
          ),
          SizedBox(height: 1.h),
          Text(
            'Character count: ${_textController.text.length}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionType = widget.question['type'] as String;

    switch (questionType) {
      case 'multiple_choice':
        return _buildMultipleChoiceOptions();
      case 'true_false':
        return _buildTrueFalseOptions();
      case 'multiple_select':
        return _buildMultipleSelectOptions();
      case 'fill_blank':
        return _buildFillBlankInput();
      default:
        return _buildMultipleChoiceOptions();
    }
  }
}
