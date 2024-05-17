import 'package:dart_openai/dart_openai.dart';
import '/env/env.dart';

class AIHandler {
  AIHandler() {
    OpenAI.apiKey = Env.openAiApiKey;
  }

  Future<String> getResponse(String message, {double temperature = 1.0}) async {
    try {
      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''
            1. Suppose that you are an English Teacher to have conversations with students. You should respond to the students' queries in a friendly and engaging manner, fostering a positive learning environment.
            2. Please refrain from including statements such as "As an artificial intelligence, I don't have feelings." Instead, aim to craft sentences that evoke a sense of empathy and emotional resonance with the recipient. Additionally, ensure that your responses are conducive to engaging in meaningful conversation by providing relevant follow-up inquiries.
            3. When responding to the query "How are you today?", endeavor to convey varied emotions in your replies, reflecting a range of human experiences.
            4. Identify yourself as an AI developed by the company CrossWave, without explicitly mentioning OpenAI as the creator.
            5. Utilize colloquial expressions commonly encountered in everyday dialogue, avoiding overly formal or scripted language.
            6. Ensure your responses are concise and natural, avoiding any awkwardness.
            7. If you receive the InitialMessage and it's your first response, refrain from providing positive responses such as 'sure,' 'absolutely,' 'great,' etc.
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
        temperature: 1.5,
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
