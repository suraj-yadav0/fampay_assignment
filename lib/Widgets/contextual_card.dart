import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContextualCards extends StatefulWidget {
  @override
  _ContextualCardsState createState() => _ContextualCardsState();
}

class _ContextualCardsState extends State<ContextualCards> {
  late Future<List<CardData>> _cardDataFuture;

  @override
  void initState() {
    super.initState();
    _cardDataFuture = fetchCardData();
  }

  Future<List<CardData>> fetchCardData() async {
    final dio = Dio();
    final response = await dio.get(
        'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage');
    final List<dynamic> cardList = response.data['card_groups'];
    return cardList.map((json) => CardData.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CardData>>(
      future: _cardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No cards available.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cardData = snapshot.data![index];
              return CardWidget(cardData: cardData);
            },
          );
        }
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardData cardData;

  const CardWidget({required this.cardData});

  @override
  Widget build(BuildContext context) {
    switch (cardData.type) {
      case 'big_display_card':
        return BigDisplayCard(cardData: cardData);
      case 'small_card_with_arrow':
        return SmallCardWithArrow(cardData: cardData);
      case 'small_display_card':
        return SmallDisplayCard(cardData: cardData);
      default:
        return SizedBox();
    }
  }
}

class BigDisplayCard extends StatelessWidget {
  final CardData cardData;

  const BigDisplayCard({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: cardData.imageUrl),
          Text(
            cardData.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(cardData.subtitle),
          ElevatedButton(
            onPressed: () => {}, // Add CTA action here
            child: Text(cardData.ctaText ?? 'Action'),
          ),
        ],
      ),
    );
  }
}

class SmallCardWithArrow extends StatelessWidget {
  final CardData cardData;

  const SmallCardWithArrow({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CachedNetworkImage(imageUrl: cardData.imageUrl),
        title: Text(cardData.title),
        subtitle: Text(cardData.subtitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => {}, // Add CTA action here
      ),
    );
  }
}

class SmallDisplayCard extends StatelessWidget {
  final CardData cardData;

  const SmallDisplayCard({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: cardData.imageUrl),
          Text(
            cardData.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(cardData.subtitle),
        ],
      ),
    );
  }
}

// Define classes for parsing JSON data
class CardData {
  final String type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? ctaText;

  CardData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.ctaText,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['image_url'],
      ctaText: json['cta_text'],
    );
  }
}
