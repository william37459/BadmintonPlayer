# BadmintonPlayer App

A Flutter application for managing and viewing badminton player profiles, tournaments, team tournaments, and results. The app is designed for Danish badminton clubs and players, providing a modern and user-friendly interface for tracking scores, rankings, and match details.

## Features

- Player profile pages with ranking and tournament history
- Team tournament search and results by region and year
- Tournament results with expandable match details
- Filter and search functionality for tournaments and teams
- Modern, responsive UI with custom theming
- Integration with badmintonplayer.dk for live data

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable)
- Dart SDK
- Android Studio or Xcode (for mobile development)

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/badmintonplayer.git
   cd badmintonplayer/app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Project Structure
- `lib/` - Main Dart source code
  - `calendar/` - Calendar and date-related widgets
  - `dashboard/` - Dashboard and overview widgets
  - `global/` - Shared classes, constants, and utilities
  - `player_profile/` - Player profile pages and widgets
  - `score_list/` - Score and ranking lists
  - `team_tournament/` - Team tournament search and results
  - `tournament_result_page/` - Tournament results and details
- `assets/` - Images and static assets
- `android/`, `ios/` - Platform-specific code

## General Structure
- `screen/`
  - `widgets/`
  - `functions/`
  - `index.dart`

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)

## Acknowledgements
- [badmintonplayer.dk](https://badmintonplayer.dk/) for data integration
- Flutter and Dart teams for the framework
