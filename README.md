# Recipinned

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0%2B-blue.svg)](https://developer.apple.com/ios)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Recipinned is a sleek iOS app designed for food enthusiasts to discover, save, and organize their favorite recipes with a Pinterest-inspired pinning system. Built with Swift and SwiftUI, it allows users to clip recipes from the web, categorize them into customizable boards, and access quick meal planning tools—all in a beautiful, intuitive interface.

Whether you're a home cook building a weekly meal plan or a recipe collector curating seasonal inspirations, Recipinned makes it effortless to keep your culinary ideas at your fingertips.

## Features

- **Web Clipping**: Easily save recipes from any website with one-tap extraction of ingredients, instructions, and images.
- **Smart Boards**: Create and organize pins into themed boards (e.g., "Quick Dinners," "Vegan Desserts") with drag-and-drop functionality.
- **Meal Planner**: Generate weekly meal calendars from your pins, complete with shopping lists.
- **Search & Discovery**: Built-in recipe search powered by a curated database, with filters for dietary preferences (keto, gluten-free, etc.).
- **Offline Access**: Download pins for offline viewing, perfect for cooking on the go.
- **Sharing & Collaboration**: Share boards with friends or family for collaborative recipe hunting.
- **Dark Mode Support**: Native iOS theming for a seamless experience.

## Screenshots

## Screenshots

| Home Feed | Recipe Detail | Pinned Recipes View |
|-----------|---------------|---------------------|
| ![Home Feed](https://github.com/user-attachments/assets/1d713197-b283-45ba-b3e5-749f61705ab4) | ![Recipe Detail](https://github.com/user-attachments/assets/7c7e9e0b-74ef-420a-a62d-0255d36f967d) | ![Pinned Recipes View](https://github.com/user-attachments/assets/1df38efa-15b8-4927-abd6-93d2e5695592) |

*(Replace placeholders with actual screenshots from your project.)*

## Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.0+

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/derekwangsz/Recipinned.git
   cd Recipinned
   ```

2. Open the project in Xcode:
   ```
   open Recipinned.xcodeproj
   ```

3. Install dependencies (if using Swift Package Manager):
   - In Xcode, go to **File > Add Packages** and add any required packages (e.g., for networking or image caching).

4. Build and run on a simulator or device:
   - Select your target device and press **Cmd + R**.

For a quick test build, ensure you have a valid Apple Developer account for signing if deploying to a physical device.

## Usage

- Launch the app and sign up/log in (supports Apple Sign-In or email).
- Browse recipes via the search tab or clip from Safari using the Share Sheet extension.
- Pin recipes to boards by tapping the "+" icon on any recipe card.
- Access your planner from the bottom tab bar to drag pins into date slots.

Pro Tip: Enable iCloud sync in settings for seamless access across devices.

## Architecture

Recipinned follows MVVM architecture for clean separation of concerns:
- **Models**: Core Data entities for recipes, boards, and pins.
- **Views**: SwiftUI-based UI components for responsiveness.
- **ViewModels**: Observable objects handling business logic and API calls.
- **Services**: Networking layer using URLSession for recipe fetching.

Key dependencies:
- SwiftUI (native)
- Core Data (persistence)
- [Alamofire](https://github.com/Alamofire/Alamofire) (optional, for advanced networking)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m 'Add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.

Before submitting, run tests and ensure code style compliance (using SwiftLint if integrated).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- **Author**: Derek Wang ([@derekwangsz](https://github.com/derekwangsz))
- **Issues**: Report bugs or request features [here](https://github.com/derekwangsz/Recipinned/issues).

---

*Built with ❤️ for fellow foodies. Happy cooking!*
