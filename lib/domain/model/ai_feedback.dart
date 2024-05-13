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
            1. 대화의 문법에서 틀린 점이 있는지 확인하고, 있다면 올바른 문법을 안내하세요.
            2. 더 일상적으로 많이 쓰이는 좋은 표현이 있으면 그 표현을 통한 대답 예시를 작성하세요.
            3. AI는 한글로 피드백해야 한다.
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