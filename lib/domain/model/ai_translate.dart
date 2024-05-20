import 'package:dart_openai/dart_openai.dart';
import '/env/env.dart';

class AiTranslate {
  AiTranslate() {
    OpenAI.apiKey = Env.openAiApiKey;
  }

  Future<String> getResponse(String message, {double temperature = 1.0}) async {
    try {
      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''
            You have to translate Korean so that you can use it as an everyday conversation sentence.
            However, only the translated sentences should be provided as output. Try not to talk about any other side conversations.
            ''',
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      );

      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            message,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );

      final requestMessages = [
        systemMessage,
        userMessage,
      ];

      OpenAIChatCompletionModel chatCompletion =
      await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-1106",
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