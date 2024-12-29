
# FamPay Assignment - Contextual Cards UI

A Flutter application that displays different types of cards in a dynamic UI based on API response. The app showcases various card designs and interactions following FamPay's design system.

## Features

- **Multiple Card Types:**
  - Big Display Card (HC3) - Featured cards with actions
  - Small Card with Arrow (HC6) - Navigational cards
  - Image Card (HC5) - Cards with background images
  - Small Display Card (HC1) - Basic info cards
  - Dynamic Width Card (HC9) - Scrollable gradient cards

- **Interactive Features:**
  - Long press to dismiss or remind later for big display cards
  - Refresh functionality to reload cards
  - URL handling for card actions
  - Horizontal scrolling for card groups
  - Card state persistence using SharedPreferences

- **UI Components:**
  - Gradient backgrounds
  - Custom icons and images
  - Action buttons
  - Loading states
  - Error handling with SnackBar notifications

## Screenshots

Below are screenshots demonstrating the app's user interface:

![Screenshot 1](https://github.com/user-attachments/assets/d6517a63-20f0-4729-bd86-6ac6c4c89821)
*Card Display Example 1*

![Screenshot 2](https://github.com/user-attachments/assets/266af0b4-de1b-4e7d-9565-b4281569821f)
*Card Display Example 2*

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cached_network_image: ^3.2.0
  shared_preferences: ^2.0.0
  url_launcher: ^6.0.0
```

## Project Structure

```
lib/
├── models/
│   ├── card_model.dart
│   └── gradient_model.dart
├── services/
│   └── api_services.dart
├── screens/
│   └── contextual_cards_screen.dart
└── main.dart
```

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/fampay_assignment.git
   ```

2. **Install dependencies:**
   ```bash
   cd fampay_assignment
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## API Integration

The app fetches card data from an API endpoint. The response includes different types of cards with various properties:

```json
{
  "card_groups": [
    {
      "design_type": "HC3",
      "cards": [
        {
          "title": "Big Display Card",
          "description": "Sample text for subtitle",
          "icon": {
            "image_url": "https://example.com/icon.png"
          },
          "url": "https://example.com"
        }
      ]
    }
  ]
}
```

## Card Types and Design Specifications

### HC3 - Big Display Card
- Height: 180px
- Background: Deep purple or gradient
- Contains: Icon, title, description, and action button
- Supports: Long press actions

### HC6 - Small Card with Arrow
- Height: Auto
- Contains: Circular icon, title, and arrow
- Used for: Navigation items

### HC5 - Image Card
- Height: 120px
- Features: Background image, title overlay
- Supports: Custom text colors

### HC1 - Small Display Card
- Height: Auto
- Background: Orange
- Contains: User avatar and name

### HC9 - Dynamic Width Cards
- Height: 120px
- Features: Horizontal scrolling, gradient backgrounds
- Width: Based on aspect ratio

## State Management

The app uses StatefulWidget to manage:
- Card loading states
- Dismissed cards
- Remind later cards
- Error states

## Persistence

Uses SharedPreferences to persist:
- Dismissed card IDs
- Remind later card IDs

## Error Handling

- Network errors
- Invalid URLs
- Missing data fallbacks
- Loading states

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- FamPay design system
- Flutter community
- All open-source dependencies used in this project

