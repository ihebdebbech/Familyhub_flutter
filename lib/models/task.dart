class Task {
  final String id;
  final String childUsername;
  final String parentUsername;
  final String title;
  final String description;
  final int amount;
  final DateTime deadline;
  final bool status;
  final String validationType;
  final String qcmQuestion;
  final String qcmOptions;
  final String answer;

  Task({
    required this.id,
    required this.childUsername,
    required this.parentUsername,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.status,
    this.validationType = "None",
    this.qcmQuestion = "None",
    this.qcmOptions = "None",
    this.answer = "None",
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      childUsername: json['childUsername'],
      parentUsername: json['parentUsername'],
      title: json['title'],
      description: json['description'],
      amount: json['amount'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      validationType: json['validationType'] ?? "None",
      qcmQuestion: json['qcmQuestion'] ?? "None",
      qcmOptions: json['qcmOptions'] ?? "None",
      answer: json['Answer'] ?? "None",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'childUsername': childUsername,
      'parentUsername': parentUsername,
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'validationType': validationType,
      'qcmQuestion': qcmQuestion,
      'qcmOptions': qcmOptions,
      'Answer': answer,
    };
  }
}