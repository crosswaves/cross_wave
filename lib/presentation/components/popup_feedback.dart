import 'package:flutter/material.dart';
import '../feedback_screen.dart';

class PopupFeedback extends StatefulWidget {
  @override
  PopupFeedbackState createState() => PopupFeedbackState();
}

class PopupFeedbackState extends State<PopupFeedback> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Text('AI로부터 피드백을 받으시겠습니까?'),
      content: const Text(
          'Would you like to provide feedback on your conversation?'),
      actions: [
        TextButton(
          onPressed: () {
            // Navigate to FeedbackScreen on button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FeedbackScreen()));
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the popup
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
