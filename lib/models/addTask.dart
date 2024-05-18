class AddTask {
  final String childUsername;
  final String parentUsername;
  final String title;
  final String description;
  final int amount;
  final String deadline; 
  final String validationType;
  final String qcmQuestion;
  final String qcmOptions;
  final String answer;

  AddTask({
    required this.childUsername,
    required this.parentUsername,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    this.validationType = "None",
    this.qcmQuestion = "None",
    this.qcmOptions = "None",
    this.answer = "None",
  });

  Map<String, dynamic> toJson() {
    return {
      'childUsername': childUsername,
      'parentUsername': parentUsername,
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline,
      'validationType': validationType,
      'qcmQuestion': qcmQuestion,
      'qcmOptions': qcmOptions,
      'Answer': answer,
    };
  }
}
