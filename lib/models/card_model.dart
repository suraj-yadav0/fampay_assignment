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