# Mera Note

A simple note-keeping app built with Flutter that uses Hive for local storage and BLoC for state management.

## Features

- Create, edit, and delete notes
- Organize notes by categories
- Filter notes by category
- Local storage using Hive
- Clean and modern UI with Material Design 3

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Categories**
   - Tap the category icon in the app bar to create a new category
   - Enter a category name and optional color
   - Categories will appear as filter chips at the top of the screen

2. **Notes**
   - Tap the + button to create a new note
   - Select a category for the note
   - Enter a title and content
   - Tap the check mark to save
   - Tap a note to edit it
   - Use the delete icon to remove a note

3. **Filtering**
   - Use the category chips at the top to filter notes by category
   - Tap "All" to show all notes

## Dependencies

- flutter_bloc: State management
- hive: Local storage
- hive_flutter: Hive Flutter integration
- path_provider: Access to system directories
- equatable: Value equality
- uuid: Unique ID generation
- intl: Date formatting

## Project Structure

```
lib/
  ├── blocs/
  │   ├── categories/
  │   │   ├── categories_bloc.dart
  │   │   ├── categories_event.dart
  │   │   └── categories_state.dart
  │   └── notes/
  │       ├── notes_bloc.dart
  │       ├── notes_event.dart
  │       └── notes_state.dart
  ├── models/
  │   ├── category.dart
  │   └── note.dart
  ├── screens/
  │   ├── home_screen.dart
  │   └── note_screen.dart
  └── main.dart
```
