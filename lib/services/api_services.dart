import 'dart:convert';
import 'package:fampay_assignment/models/card_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section';
  
  Future<List<CardGroup>> fetchContextualCards() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/?slugs=famx-paypage'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<CardGroup> cardGroups = [];
        
        for (var item in data) {
          if (item['hc_groups'] != null) {
            for (var group in item['hc_groups']) {
              cardGroups.add(CardGroup.fromJson(group));
            }
          }
        }
        
        return cardGroups;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }
}