import 'package:fampay_assignment/models/card_model.dart' as card_model;
import 'package:fampay_assignment/models/card_model.dart';
import 'package:fampay_assignment/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContextualCardsScreen extends StatefulWidget {
  const ContextualCardsScreen({super.key});

  @override
  State<ContextualCardsScreen> createState() => _ContextualCardsScreenState();
}

class _ContextualCardsScreenState extends State<ContextualCardsScreen> {
  final ApiService _apiService = ApiService();
  final Set<int> _dismissedCards = {};
  final Set<int> _remindLaterCards = {};
  List<card_model.CardGroup> _cardGroups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadDismissedCards();
    await _loadCards();
  }

  Future<void> _loadDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dismissedCards.addAll(
        prefs
                .getStringList('dismissed_cards')
                ?.map(int.parse)
                .whereType<int>() ??
            [],
      );
      _remindLaterCards.addAll(
        prefs
                .getStringList('remind_later_cards')
                ?.map(int.parse)
                .whereType<int>() ??
            [],
      );
    });
  }

  Future<void> _saveDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setStringList(
        'dismissed_cards',
        _dismissedCards.map((id) => id.toString()).toList(),
      ),
      prefs.setStringList(
        'remind_later_cards',
        _remindLaterCards.map((id) => id.toString()).toList(),
      ),
    ]);
  }

  Future<void> _loadCards() async {
    try {
      setState(() => _isLoading = true);
      final cards = await _apiService.fetchContextualCards();
      if (mounted) {
        setState(() {
          _cardGroups = cards;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Error loading cards');
      }
    }
  }

  Future<void> _handleUrl(String? url) async {
    if (url == null) return;

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open link');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Invalid URL');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }
 Widget _buildSmallDisplayCard(ContextualCard card) {
    return Container(
     
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: card.icon?.imageUrl != null
                ? Image.network(
                    card.icon!.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person, color: Colors.black54),
            ),
          ),
          title: Text(
            // card.formattedTitle?.text ?? 
            // card.title ?? 
            'Small display card',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          subtitle: card.description != null 
            ? Text(
                'Arya Stark',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 12,
                ),
              )
            : null,
        ),
      ),
    );
  }

  Widget? _buildCardIcon(card_model.ContextualCard card) {
    if (card.icon?.imageUrl == null) return null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: CachedNetworkImage(
        imageUrl: card.icon!.imageUrl!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox(
          width: 50,
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

 Widget _buildBigDisplayCard(ContextualCard card) {
    if (_dismissedCards.contains(card.id) ||
        _remindLaterCards.contains(card.id)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 350,
      child: GestureDetector(
        onLongPress: () => _showActionButtons(card),
        onTap: () => _handleUrl(card.url),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple[700], // Default purple background
              borderRadius: BorderRadius.circular(12),
              gradient: _buildGradient(card.bgGradient),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    Image.asset("assets/Asset 15.png"),
                    // if (card.icon?.imageUrl != null)
                    //   Container(
                    //     width: 64,
                    //     height: 64,
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //      // color: Colors.white.withOpacity(0.2),
                    //     ),
                    //     padding: const EdgeInsets.all(12),
                    //     child: Image.network(
                    //       card.icon!.imageUrl!,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  
                  'Big display card with action',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card.formattedDescription?.text ?? 
                  card.description ?? 
                  'This is a sample text for the subtitle that you can add to contextual cards.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _handleUrl(card.url),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(128, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Action'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  LinearGradient? _buildGradient(card_model.Gradient? gradient) {
    
    if (gradient == null) return null;

    return LinearGradient(
      colors: gradient.colors.map(_parseColor).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // DecorationImage? _buildBackgroundImage(CardImage? bgImage) {
  //   if (bgImage?.imageUrl == null) return null;

  //   return DecorationImage(
  //     image: CachedNetworkImageProvider(bgImage!.imageUrl!),
  //     fit: BoxFit.cover,
  //   );
  // }

  // Widget _buildCardTitle(ContextualCard card) {
  //   final title = card.formattedTitle?.text ?? card.title;
  //   if (title == null) return const SizedBox.shrink();

  //   return Text(
  //     title,
  //     style: const TextStyle(
  //       color: Colors.black,
  //       fontSize: 24,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  // Widget _buildCardDescriptionText(ContextualCard card) {
  //   final description = card.formattedDescription?.text ?? card.description;
  //   if (description == null) return const SizedBox.shrink();

  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8),
  //     child: Text(
  //       description,
  //       style: TextStyle(
  //         // ignore: deprecated_member_use
  //        // color: Colors.white.withOpacity(0.8),
  //         fontSize: 16,
  //       ),
  //     ),
  //   );
  // }
 Widget _buildCtaButtons(ContextualCard card) {
    if (card.cta.isEmpty) {
      // Add a default action button if no CTA is provided
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        child: const Text('Action'),
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: card.cta.map((cta) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ElevatedButton(
          onPressed: () => _handleUrl(cta.url),
          style: ElevatedButton.styleFrom(
            backgroundColor: cta.bgColor != null 
              ? _parseColor(cta.bgColor!) 
              : Colors.black,
            foregroundColor: cta.textColor != null
              ? _parseColor(cta.textColor!)
              : Colors.white,
          ),
          child: Text(cta.text),
        ),
      )).toList(),
    );
  }



  void _showActionButtons(ContextualCard card) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Remind Later',style: TextStyle(color: Colors.white),),
              onTap: () => _handleCardAction(card, isRemindLater: true),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Dismiss Now'),
              onTap: () => _handleCardAction(card, isRemindLater: false),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardAction(ContextualCard card, {required bool isRemindLater}) {
    setState(() {
      if (isRemindLater) {
        _remindLaterCards.add(card.id);
      } else {
        _dismissedCards.add(card.id);
      }
    });
    _saveDismissedCards();
    Navigator.pop(context);
  }

  Widget _buildCardGroup(CardGroup group) {
    switch (group.designType) {
      case 'HC3':
        return _buildBigDisplayCard(group.cards.first);
      case 'HC6':
        return _buildSmallCardWithArrow(group.cards.first);
      case 'HC5':
        return Column(
          children: group.cards.map((card) => _buildImageCard(card)).toList(),
        );
      case 'HC9':
        return SizedBox(
          
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: group.cards.length,
            itemBuilder: (context, index) => _buildDynamicWidthCard(group.cards[index]),
          ),
        );
      default:
        return _buildSmallDisplayCard(group.cards.first);
    }
  }

  // Widget _buildCard(ContextualCard card, String designType, double? height) {
  //   switch (designType) {
  //     case 'HC1':
  //       return _buildSmallDisplayCard(card);
  //     case 'HC3':
  //       return _buildBigDisplayCard(card);
  //     case 'HC5':
  //       return _buildImageCard(card);
  //     case 'HC6':
  //       return _buildSmallCardWithArrow(card);
  //     case 'HC9':
  //       return _buildDynamicWidthCard(card);
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

  Widget _buildImageCard(ContextualCard card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 130,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () => _handleUrl(card.url),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (card.bgImage?.imageUrl != null)
                Image.network(
                  card.bgImage!.imageUrl!,
                  fit: BoxFit.cover,
                ),
              // Positioned(
              //   left: 16,
              //   bottom: 16,
              //   child: Text(
              //     card.formattedTitle?.text ?? 
              //     card.title ?? 
              //     'Image Card',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
    
  Widget _buildSmallCardWithArrow(ContextualCard card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Small card with arrow',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, 
            size: 16,
            color: Colors.black54,
          ),
          onTap: () => _handleUrl(card.url),
        ),
      ),
    );
  }

 Widget _buildDynamicWidthCard(ContextualCard card) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: _buildGradient(card.bgGradient),
          ),
        ),
      ),
    );
  }

  // double _calculateCardWidth(
  //     ContextualCard card, String designType, double? height) {
  //   switch (designType) {
  //     case 'HC9':
  //       final width =
  //           (height ?? 120) * _getAspectRatio(card.bgImage?.imageUrl ?? '');
  //       return width.isFinite ? width : MediaQuery.of(context).size.width - 32;
  //     case 'HC3':
  //     case 'HC5':
  //       return MediaQuery.of(context).size.width - 32;
  //     default:
  //       return MediaQuery.of(context).size.width - 32;
  //   }
  // }

  // double _getAspectRatio(String imageUrl) {
  //   if (!imageUrl.contains('aspect_ratio=')) return 1.0;
  //   try {
  //     final aspectRatio = double.tryParse(
  //       imageUrl.split('aspect_ratio=')[1].split('&')[0],
  //     );
  //     return aspectRatio?.isFinite == true ? aspectRatio! : 1.0;
  //   } catch (e) {
  //     return 1.0;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'fampay',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
            ],
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _loadCards,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _cardGroups.length,
                  itemBuilder: (context, index) => _buildCardGroup(_cardGroups[index]),
                ),
        ),
      ),
    );
  }
}