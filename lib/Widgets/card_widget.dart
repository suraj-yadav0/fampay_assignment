import 'package:fampay_assignment/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BigDisplayCard extends StatelessWidget {
  final ContextualCard card;
  final VoidCallback? onDismiss;
  final VoidCallback? onRemindLater;
  
  const BigDisplayCard({
    Key? key,
    required this.card,
    this.onDismiss,
    this.onRemindLater,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Show slide action buttons
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.alarm),
                title: Text('Remind Later'),
                onTap: () {
                  Navigator.pop(context);
                  onRemindLater?.call();
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Dismiss Now'),
                onTap: () {
                  Navigator.pop(context);
                  onDismiss?.call();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: card.bgColor != null
              ? Color(int.parse(card.bgColor!.substring(1), radix: 16) + 0xFF000000)
              : null,
          borderRadius: BorderRadius.circular(12),
          gradient: card.bgGradient != null
              ? LinearGradient(
                  colors: card.bgGradient!.colors
                      .map((c) => Color(int.parse(c.substring(1), radix: 16) + 0xFF000000))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.formattedTitle != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  card.formattedTitle!.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Add other card content here
          ],
        ),
      ),
    );
  }
}