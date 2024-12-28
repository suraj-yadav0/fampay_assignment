class CardCTA {
  final String text;
  final String? textColor;
  final String? bgColor;
  final String? url;
  final CTAAction? clickAction;

  const CardCTA({
    required this.text,
    this.textColor,
    this.bgColor,
    this.url,
    this.clickAction,
  });

  // Create CTA from JSON
  factory CardCTA.fromJson(Map<String, dynamic> json) {
    return CardCTA(
      text: json['text'] ?? '',
      textColor: json['text_color'],
      bgColor: json['bg_color'],
      url: json['url'],
      clickAction: json['click_action'] != null 
          ? CTAAction.fromJson(json['click_action'])
          : null,
    );
  }

  // Convert CTA to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'text_color': textColor,
      'bg_color': bgColor,
      'url': url,
      'click_action': clickAction?.toJson(),
    };
  }

  // Create a copy of CTA with some fields replaced
  CardCTA copyWith({
    String? text,
    String? textColor,
    String? bgColor,
    String? url,
    CTAAction? clickAction,
  }) {
    return CardCTA(
      text: text ?? this.text,
      textColor: textColor ?? this.textColor,
      bgColor: bgColor ?? this.bgColor,
      url: url ?? this.url,
      clickAction: clickAction ?? this.clickAction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CardCTA &&
      other.text == text &&
      other.textColor == textColor &&
      other.bgColor == bgColor &&
      other.url == url &&
      other.clickAction == clickAction;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      textColor.hashCode ^
      bgColor.hashCode ^
      url.hashCode ^
      clickAction.hashCode;
  }

  @override
  String toString() {
    return 'CardCTA(text: $text, textColor: $textColor, bgColor: $bgColor, url: $url, clickAction: $clickAction)';
  }
}

// Enum for different types of CTA actions
enum CTAActionType {
  deepLink,
  webUrl,
  share,
  none;

  factory CTAActionType.fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'deeplink':
        return CTAActionType.deepLink;
      case 'weburl':
        return CTAActionType.webUrl;
      case 'share':
        return CTAActionType.share;
      default:
        return CTAActionType.none;
    }
  }
}

// Class to handle CTA click actions
class CTAAction {
  final CTAActionType type;
  final String? value;
  final Map<String, dynamic>? extras;

  const CTAAction({
    required this.type,
    this.value,
    this.extras,
  });

  factory CTAAction.fromJson(Map<String, dynamic> json) {
    return CTAAction(
      type: CTAActionType.fromString(json['type']),
      value: json['value'],
      extras: json['extras'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'value': value,
      'extras': extras,
    };
  }

  CTAAction copyWith({
    CTAActionType? type,
    String? value,
    Map<String, dynamic>? extras,
  }) {
    return CTAAction(
      type: type ?? this.type,
      value: value ?? this.value,
      extras: extras ?? this.extras,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CTAAction &&
      other.type == type &&
      other.value == value &&
      _mapEquals(other.extras, extras);
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode ^ extras.hashCode;

  @override
  String toString() => 'CTAAction(type: $type, value: $value, extras: $extras)';
}

// Helper function to compare maps
bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  return a.entries.every((e) => b.containsKey(e.key) && b[e.key] == e.value);
}