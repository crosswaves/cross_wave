import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY')
  static const String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;
  @EnviedField(varName: 'FIREBASE_IOS_API_KEY')
  static const String firebaseIosApiKey = _Env.firebaseIosApiKey;
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static const String openAiApiKey = _Env.openAiApiKey;
}