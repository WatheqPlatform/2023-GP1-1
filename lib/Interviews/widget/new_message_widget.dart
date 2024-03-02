import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const NewMessageWidget({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
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
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 52,
              height: 45,
              child: MaterialButton(
                shape: const CircleBorder(),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  widget.onSubmitted(controller.text);
                  controller.clear();
                },
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
