part of 'event_form_notifier.dart';

class EventFormState {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool useOccurrences;
  final String title;
  final String description;
  final RepeatFrequency? repeatFrequency;
  final bool enableNotifications;

  final int? occurrences;
  final DateTime? endDate;
  final bool isLoading;
  final String? errorMessage;

  EventFormState({
    this.enableNotifications = false,
    required this.title,
    required this.description,
    required this.repeatFrequency,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.useOccurrences,
    this.occurrences,
    this.endDate,
    this.isLoading = false,
    this.errorMessage,
  });

  EventFormState copyWith({
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? useOccurrences,
    String? title,
    String? description,
    RepeatFrequency? repeatFrequency,
    int? occurrences,
    DateTime? endDate,
    bool? isLoading,
    String? errorMessage,
    bool? enableNotifications,
  }) {
    return EventFormState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      useOccurrences: useOccurrences ?? this.useOccurrences,
      title: title ?? this.title,
      description: description ?? this.description,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      occurrences: occurrences ?? this.occurrences,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }
}
