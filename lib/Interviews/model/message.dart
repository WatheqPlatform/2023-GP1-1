class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe; //True if the user flase if Chat-GPT

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}
