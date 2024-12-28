class CardGroup {
  final int id;
  final String name;
  final String designType;
  final List<ContextualCard> cards;
  final bool isScrollable;
  final double? height;
  final bool isFullWidth;
  
  CardGroup({
    required this.id,
    required this.name,
    required this.designType,
    required this.cards,
    required this.isScrollable,
    this.height,
    required this.isFullWidth,
  });
  
  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      id: json['id'],
      name: json['name'],
      designType: json['design_type'],
      cards: (json['cards'] as List)
          .map((card) => ContextualCard.fromJson(card))
          .toList(),
      isScrollable: json['is_scrollable'] ?? false,
      height: json['height']?.toDouble(),
      isFullWidth: json['is_full_width'] ?? false,
    );
  }
}

class ContextualCard {
  final int id;
  final String name;
  final String? title;
  final FormattedText? formattedTitle;
  final String? description;
  final FormattedText? formattedDescription;
  final CardImage? icon;
  final String? url;
  final CardImage? bgImage;
  final String? bgColor;
  final Gradient? bgGradient;
  final List<CallToAction> cta;
  
  ContextualCard({
    required this.id,
    required this.name,
    this.title,
    this.formattedTitle,
    this.description,
    this.formattedDescription,
    this.icon,
    this.url,
    this.bgImage,
    this.bgColor,
    this.bgGradient,
    required this.cta,
  });
  
  factory ContextualCard.fromJson(Map<String, dynamic> json) {
    return ContextualCard(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      description: json['description'],
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      url: json['url'],
      bgImage: json['bg_image'] != null
          ? CardImage.fromJson(json['bg_image'])
          : null,
      bgColor: json['bg_color'],
      bgGradient: json['bg_gradient'] != null
          ? Gradient.fromJson(json['bg_gradient'])
          : null,
      cta: json['cta'] != null
          ? (json['cta'] as List)
              .map((cta) => CallToAction.fromJson(cta))
              .toList()
          : [],
    );
  }
}


class FormattedText {
  final String text;
  final List<Entity> entities;
  
  FormattedText({required this.text, required this.entities});
  
  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'],
      entities: (json['entities'] as List)
          .map((entity) => Entity.fromJson(entity))
          .toList(),
    );
  }
}



class Entity {
  final String text;
  final String? color;
  final String? url;
  final String? fontStyle;
  
  Entity({
    required this.text,
    this.color,
    this.url,
    this.fontStyle,
  });
  
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? '',
      color: json['color'],
      url: json['url'],
      fontStyle: json['font_style'],
    );
  }
}

class CardImage {
  final String imageType;
  final String? imageUrl;
  final String? assetType;
  
  CardImage({
    required this.imageType,
    this.imageUrl,
    this.assetType,
  });
  
  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageType: json['image_type'],
      imageUrl: json['image_url'],
      assetType: json['asset_type'],
    );
  }
}

class CallToAction {
  final String text;
  final String? bgColor;
  final String? url;
  final String? textColor;
  
  CallToAction({
    required this.text,
    this.bgColor,
    this.url,
    this.textColor,
  });
  
  factory CallToAction.fromJson(Map<String, dynamic> json) {
    return CallToAction(
      text: json['text'],
      bgColor: json['bg_color'],
      url: json['url'],
      textColor: json['text_color'],
    );
  }
}

class Gradient {
  final List<String> colors;
  final double angle;
  
  Gradient({required this.colors, required this.angle});
  
  factory Gradient.fromJson(Map<String, dynamic> json) {
    return Gradient(
      colors: (json['colors'] as List).cast<String>(),
      angle: (json['angle'] ?? 0).toDouble(),
    );
  }
}


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