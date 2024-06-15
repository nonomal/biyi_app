import 'package:uni_translate_client/uni_translate_client.dart';

class TranslationEngineConfig {
  TranslationEngineConfig({
    this.position = -1,
    this.group,
    required this.id,
    required this.type,
    this.supportedScopes = const [],
    required this.option,
    this.disabled = false,
  });

  factory TranslationEngineConfig.fromJson(Map<dynamic, dynamic> json) {
    return TranslationEngineConfig(
      position: json['position'] ?? -1,
      group: json['group'],
      id: json['identifier'] ?? json['id'],
      type: json['type'],
      supportedScopes: json['supportedScopes'] != null
          ? List<String>.from(json['supportedScopes'])
              .map(
                (e) => TranslationEngineScope.values
                    .firstWhere((v) => e == v.name),
              )
              .toList()
          : [],
      option: Map<String, dynamic>.from(json['option'] ?? {}),
      disabled: json['disabled'] ?? false,
    );
  }

  int position;
  String? group;
  final String id;
  String type;
  List<TranslationEngineScope> supportedScopes;
  Map<String, dynamic> option;
  bool disabled = false;

  bool get isProGroup => group == 'pro';

  @Deprecated('No longer used')
  String get identifier => id;

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'group': group,
      'id': id,
      'type': type,
      'supportedScopes': supportedScopes,
      'option': option,
      'disabled': disabled,
    };
  }
}
