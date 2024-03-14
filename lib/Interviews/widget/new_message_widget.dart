import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final bool isEnabled;
  const NewMessageWidget({
    Key? key,
    required this.onSubmitted,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final controller = TextEditingController();

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            if (widget.isEnabled)
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  elevation: 3,
                  child: TextField(
                    controller: controller,
                    onSubmitted: widget.onSubmitted,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                      hintText: 'Type your answer here...',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                    enabled: widget.isEnabled,
                    textInputAction: TextInputAction.send,
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if (widget.isEnabled) // Show send button only if input is enabled
              SizedBox(
                width: 52,
                height: 45,
                child: MaterialButton(
                  shape: const CircleBorder(),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    sendMessage();
                  },
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
          ],
        ),
      );
}
