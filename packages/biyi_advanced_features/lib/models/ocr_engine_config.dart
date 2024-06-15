class OcrEngineConfig {
  OcrEngineConfig({
    this.position = -1,
    this.group,
    required this.id,
    required this.type,
    required this.option,
    this.disabled = false,
  });

  factory OcrEngineConfig.fromJson(Map<dynamic, dynamic> json) {
    return OcrEngineConfig(
      position: json['position'] ?? -1,
      group: json['group'],
      id: json['id'] ?? json['identifier'],
      type: json['type'],
      option: Map<String, dynamic>.from(json['option'] ?? {}),
      disabled: json['disabled'] ?? false,
    );
  }

  int position;
  String? group;
  final String id;
  String type;
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
      'option': option,
      'disabled': disabled,
    };
  }
}
