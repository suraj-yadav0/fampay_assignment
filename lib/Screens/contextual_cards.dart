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

  Widget _buildSmallDisplayCard(card_model.ContextualCard card) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        child: ListTile(
          leading: _buildCardIcon(card),
          title: Text(
            card.formattedTitle?.text ?? card.title ?? 'Small Display card',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: _buildCardDescription(card),
          onTap: () => _handleUrl(card.url),
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

  Widget? _buildCardDescription(card_model.ContextualCard card) {
    final description = card.formattedDescription?.text ?? card.description;
    if (description == null) return null;

    return Text(description);
  }

  Widget _buildBigDisplayCard(ContextualCard card) {
    if (_dismissedCards.contains(card.id) ||
        _remindLaterCards.contains(card.id)) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: GestureDetector(
        onLongPress: () => _showActionButtons(card),
        onTap: () => _handleUrl(card.url),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: card.bgColor != null ? _parseColor(card.bgColor!) : null,
            borderRadius: BorderRadius.circular(12),
            gradient: _buildGradient(card.bgGradient),
            image: _buildBackgroundImage(card.bgImage),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildCardTitle(card),
              _buildCardDescriptionText(card),
              _buildCtaButtons(card),
            ],
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

  DecorationImage? _buildBackgroundImage(CardImage? bgImage) {
    if (bgImage?.imageUrl == null) return null;

    return DecorationImage(
      image: CachedNetworkImageProvider(bgImage!.imageUrl!),
      fit: BoxFit.cover,
    );
  }

  Widget _buildCardTitle(ContextualCard card) {
    final title = card.formattedTitle?.text ?? card.title;
    if (title == null) return const SizedBox.shrink();

    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCardDescriptionText(ContextualCard card) {
    final description = card.formattedDescription?.text ?? card.description;
    if (description == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        description,
        style: TextStyle(
          // ignore: deprecated_member_use
         // color: Colors.white.withOpacity(0.8),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCtaButtons(ContextualCard card) {
    if (card.cta.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: card.cta.map((cta) => _buildCtaButton(cta)).toList(),
        ),
      ),
    );
  }

  Widget _buildCtaButton(CallToAction cta) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _handleUrl(cta.url),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              cta.bgColor != null ? _parseColor(cta.bgColor!) : Colors.white,
          foregroundColor: cta.textColor != null
              ? _parseColor(cta.textColor!)
              : Colors.black,
        ),
        child: Text(cta.text),
      ),
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
    if (group.isScrollable) {
      return SizedBox(
        height: group.height ?? 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: group.cards.length,
          itemBuilder: (context, index) {
            final card = group.cards[index];
            return SizedBox(
              width: _calculateCardWidth(card, group.designType, group.height),
              child: _buildCard(card, group.designType, group.height),
            );
          },
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: group.cards
          .map((card) => _buildCard(card, group.designType, group.height))
          .toList(),
    );
  }

  Widget _buildCard(ContextualCard card, String designType, double? height) {
    switch (designType) {
      case 'HC1':
        return _buildSmallDisplayCard(card);
      case 'HC3':
        return _buildBigDisplayCard(card);
      case 'HC5':
        return _buildImageCard(card);
      case 'HC6':
        return _buildSmallCardWithArrow(card);
      case 'HC9':
        return _buildDynamicWidthCard(card, height ?? 120);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageCard(ContextualCard card) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: GestureDetector(
        onTap: () => _handleUrl(card.url),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: card.bgImage?.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: card.bgImage!.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCardWithArrow(ContextualCard card) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: card.icon?.imageUrl != null
              ? CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(card.icon!.imageUrl!),
                )
              : null,
          title: Text(
            card.formattedTitle?.text ?? card.title ?? 'Small Card With Arrow',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _handleUrl(card.url),
        ),
      ),
    );
  }

  Widget _buildDynamicWidthCard(ContextualCard card, double height) {
    if (card.bgImage?.imageUrl == null) return const SizedBox.shrink();

    final aspectRatio = _getAspectRatio(card.bgImage!.imageUrl!);
    final width = height * aspectRatio;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: GestureDetector(
        onTap: () => _handleUrl(card.url),
        child: Container(
          height: height,
          width: width,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: _buildGradient(card.bgGradient),
            image: _buildBackgroundImage(card.bgImage),
          ),
        ),
      ),
    );
  }

  double _calculateCardWidth(
      ContextualCard card, String designType, double? height) {
    switch (designType) {
      case 'HC9':
        final width =
            (height ?? 120) * _getAspectRatio(card.bgImage?.imageUrl ?? '');
        return width.isFinite ? width : MediaQuery.of(context).size.width - 32;
      case 'HC3':
      case 'HC5':
        return MediaQuery.of(context).size.width - 32;
      default:
        return MediaQuery.of(context).size.width - 32;
    }
  }

  double _getAspectRatio(String imageUrl) {
    if (!imageUrl.contains('aspect_ratio=')) return 1.0;
    try {
      final aspectRatio = double.tryParse(
        imageUrl.split('aspect_ratio=')[1].split('&')[0],
      );
      return aspectRatio?.isFinite == true ? aspectRatio! : 1.0;
    } catch (e) {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'F A M P A Y',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCards,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cardGroups.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No cards available',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCards,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cardGroups.length,
                    itemBuilder: (context, index) =>
                        _buildCardGroup(_cardGroups[index]),
                  ),
      ),
    );
  }
}
