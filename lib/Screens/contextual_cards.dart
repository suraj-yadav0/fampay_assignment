import 'package:fampay_assignment/models/card_model.dart' as card_model;
import 'package:fampay_assignment/models/card_model.dart';
import 'package:fampay_assignment/services/api_services.dart';
import 'package:flutter/material.dart';

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
                  
                  'Big display card ',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               
                Text(
                  
                  'with action',
                  style: const TextStyle(
                    color: Colors.white,
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

 

  void _showActionButtons(ContextualCard card) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Remind Later',style: TextStyle(color: Colors.black),),
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