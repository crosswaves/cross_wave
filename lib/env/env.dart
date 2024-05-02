import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env') //give full path here with name like secret.env instead of only extension
abstract class Env {
  @EnviedField(varName: 'FB_ANDROID_API_KEY')
  static const String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;
  @EnviedField(varName: 'FB_IOS_API_KEY')
  static const String firebaseIosApiKey = _Env.firebaseIosApiKey;
}