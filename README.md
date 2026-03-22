# Fin Flow

A personal finance manager that helps you understand your spending by categorizing transactions through an intuitive swipe gesture.

## Features

- Log transactions with a title and amount
- Swipe right to mark as **Need** (essential expense)
- Swipe left to mark as **Want** (optional expense)
- Visual balance overview
- Clean dark UI with Emerald and Coral color scheme

## Highlight: SwipeableTransaction Widget

The core interaction is a custom `SwipeableTransaction` widget built with `GestureDetector`. Swiping reveals a colored background — green for Needs, coral for Wants — giving immediate visual feedback before the action is confirmed.

```dart
SwipeableTransaction(
  transactionTitle: 'Coffee',
  onSwipeRight: () => markAsNeed(),
  onSwipeLeft: () => markAsWant(),
)
```

## Tech Stack

- Flutter + Dart
- Custom gesture-based widget
- Clean presentation layer

