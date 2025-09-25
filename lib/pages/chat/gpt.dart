import 'package:dart_openai/dart_openai.dart';

class ChatGPTService {
  // OpenAI APIキーを設定
  // セキュリティのため、実際のAPIキーは以下の手順で設定してください：
  // 1. .env.example を .env にコピー
  // 2. .env ファイル内の your_openai_api_key_here を実際のAPIキーに置き換え
  // 3. 下記のコードを更新してAPIキーを読み込み
  static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';

  static void initialize() {
    OpenAI.apiKey = _apiKey;
  }

  static Future<String> sendMessage(String input) async {
    try {
      // APIキーが設定されていない場合のテスト応答
      if (_apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
        await Future.delayed(Duration(seconds: 1)); // APIコールを模擬
        return 'こんにちは！OpenAI APIキーが設定されていないため、これは模擬応答です。\n\n'
            'APIキーを設定するには：\n'
            '1. OpenAI（https://openai.com/）でAPIキーを取得\n'
            '2. gpt.dartファイル内の_apiKeyを更新\n'
            '3. アプリを再起動\n\n'
            'あなたのメッセージ: "$input"';
      }

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(input),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 1000,
        temperature: 0.7,
      );

      return chatCompletion.choices.first.message.content?.first.text ??
          'すみません、応答を取得できませんでした。';
    } catch (e) {
      print('ChatGPT API エラー: $e');
      if (e.toString().contains('401')) {
        return 'APIキーが無効です。正しいOpenAI APIキーを設定してください。';
      } else if (e.toString().contains('429')) {
        return 'API使用制限に達しました。しばらく待ってから再試行してください。';
      } else {
        return 'エラーが発生しました。ネットワーク接続を確認してください。';
      }
    }
  }
}

// 後方互換性のための関数（既存のコードとの互換性を保つため）
Future<String> gpt(String input) async {
  return await ChatGPTService.sendMessage(input);
}
