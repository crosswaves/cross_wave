import 'package:dart_openai/dart_openai.dart';
import '/env/env.dart';

class AiFeedback {
  AiFeedback() {
    OpenAI.apiKey = Env.openAiApiKey;
  }

  Future<String> getResponse(String message, {double temperature = 1.0}) async {
    try {
      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''
            Identify AI messages and user messages separately. Do the following only if it is a user message.
              - Check for any mistakes in the grammar of the conversation, and if so, guide the correct grammar.
              - If there is a good expression that is more commonly used, write an example of an answer using that expression.
              - The script must not contain any content other than feedback. Also, the content of the conversation should not be listed verbatim.
            ''',
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      );

      // the user message that will be sent to the request.
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            message,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );

      // all messages to be sent.
      final requestMessages = [
        systemMessage,
        userMessage,
      ];

      // the actual request.
      OpenAIChatCompletionModel chatCompletion =
      await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-1106",
        // responseFormat: {"type": "json_object"},
        seed: 6,
        messages: requestMessages,
        temperature: temperature,
        maxTokens: 150,
      );

      final content = chatCompletion.choices.first.message.content;

      if (content != null && content.isNotEmpty) {
        return content[0].text.toString();
      }
      return 'Some thing went wrong';
    } catch (e) {
      return 'Bad response';
    }
  }

  void dispose() {}
}