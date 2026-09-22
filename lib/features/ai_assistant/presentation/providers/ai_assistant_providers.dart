import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ai_message.dart';

class AiAssistantState {
  final List<AiMessage> messages;
  final bool isTyping;

  const AiAssistantState({
    required this.messages,
    this.isTyping = false,
  });

  AiAssistantState copyWith({
    List<AiMessage>? messages,
    bool? isTyping,
  }) {
    return AiAssistantState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AiAssistantNotifier extends StateNotifier<AiAssistantState> {
  AiAssistantNotifier()
      : super(
          AiAssistantState(
            messages: [
              AiMessage(
                id: 'welcome_msg',
                text: 'Hello! 👋 I am **EduAI**, your personal 24/7 Learning Assistant.\n\n'
                    'I can explain complex topics, review code, quiz your knowledge, or guide your study path. What would you like to explore today?',
                isUser: false,
                timestamp: DateTime.now(),
                suggestedPrompts: const [
                  'Explain Clean Architecture',
                  'Quiz me on Flutter',
                  'How to connect Spring Boot?',
                  'Tips for mastering Dart',
                ],
              ),
            ],
          ),
        );

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = AiMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    // Realistic intelligent response simulation
    await Future.delayed(const Duration(milliseconds: 900));

    final aiReplyText = _generateSmartResponse(trimmed);
    final aiMessage = AiMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      text: aiReplyText,
      isUser: false,
      timestamp: DateTime.now(),
      suggestedPrompts: _getDynamicFollowUps(trimmed),
    );

    state = state.copyWith(
      messages: [...state.messages, aiMessage],
      isTyping: false,
    );
  }

  void clearConversation() {
    state = AiAssistantState(
      messages: [
        AiMessage(
          id: 'welcome_msg_reset',
          text: 'Conversation cleared! ✨ How can I assist your learning next?',
          isUser: false,
          timestamp: DateTime.now(),
          suggestedPrompts: const [
            'Explain Clean Architecture',
            'Quiz me on Flutter',
            'How to connect Spring Boot?',
            'Create a 7-day study plan',
          ],
        ),
      ],
      isTyping: false,
    );
  }

  String _generateSmartResponse(String prompt) {
    final lower = prompt.toLowerCase();

    if (lower.contains('clean architecture')) {
      return '### 🏛️ Clean Architecture in Flutter\n\n'
          'Clean Architecture divides your application into distinct, decoupled layers:\n\n'
          '1. **Presentation Layer**: UI Widgets, StateNotifier, Riverpod Providers.\n'
          '2. **Domain Layer (Core)**: Pure business rules with **Entities**, **Use Cases**, and **Repository Interfaces**. Independent of Flutter framework.\n'
          '3. **Data Layer**: Concrete **Repository Implementations**, **DTO Models** (`fromJson`/`toJson`), and **Data Sources** (REST API / Local DB).\n\n'
          '💡 **Key Benefit**: You can swap your backend (e.g. from Fake API to Spring Boot) by changing just the DataSource without touching any UI code!';
    }

    if (lower.contains('spring boot') || lower.contains('backend')) {
      return '### 🍃 Spring Boot + Flutter Integration\n\n'
          'To connect this Flutter app to your Spring Boot REST API:\n\n'
          '1. **Endpoints**: Spring Boot `@RestController` provides endpoints like `/api/v1/courses` returning JSON.\n'
          '2. **Toggle in App**: In `lib/app/config/app_config.dart`, set:\n'
          '```dart\n'
          'static const bool useFakeApi = false;\n'
          '```\n'
          '3. **Base URL**: Set your server URL in `lib/app/config/api_config.dart`:\n'
          '```dart\n'
          'static const String baseUrl = "http://10.0.2.2:8080/api/v1";\n'
          '```\n'
          '*(Note: `10.0.2.2` maps to localhost inside Android emulator)*.';
    }

    if (lower.contains('quiz') || lower.contains('test me') || lower.contains('practice')) {
      return '### 🎯 Quick Knowledge Check!\n\n'
          '**Question**: In Riverpod 2.0, why should you prefer `ref.watch()` over `ref.read()` inside a widget\'s `build` method?\n\n'
          'A) `ref.read()` crashes the compiler\n'
          'B) `ref.watch()` subscribes to changes and rebuilds the UI when state updates\n'
          'C) `ref.watch()` is only for asynchronous providers\n\n'
          '*Think about it, or reply with your answer!*';
    }

    if (lower.contains('b') && lower.length < 30) {
      return '🎉 **Correct!** Option **B** is right!\n\n'
          '`ref.watch()` establishes a reactive subscription so your widget automatically rebuilds whenever the observed state changes. `ref.read()` is meant for event callbacks like `onPressed`.';
    }

    if (lower.contains('study plan') || lower.contains('7-day') || lower.contains('plan')) {
      return '### 📅 Recommended 7-Day Mastery Plan\n\n'
          '- **Day 1-2**: Complete *Flutter 3.x Deep Dive* and core widget mechanics.\n'
          '- **Day 3**: Master *Riverpod 2.0* StateNotifier and Clean Architecture layers.\n'
          '- **Day 4**: Practice video lessons & review materials on *Spring Boot REST APIs*.\n'
          '- **Day 5**: Take Lesson Quizzes and achieve ≥80% score.\n'
          '- **Day 6**: Submit the course Assignment for grading.\n'
          '- **Day 7**: Download your verified Course Completion Certificate! 🎓';
    }

    if (lower.contains('flutter') || lower.contains('dart')) {
      return '### ⚡ Flutter & Dart Best Practices\n\n'
          '- **Immutability**: Always use `const` constructors wherever possible to optimize element rebuilds.\n'
          '- **State Separation**: Keep business logic in Use Cases and Riverpod Notifiers, not inside UI widgets.\n'
          '- **Async Handling**: Use `AsyncValue` in Riverpod to handle `data`, `loading`, and `error` states gracefully.';
    }

    return 'That is an insightful question about **"$prompt"**!\n\n'
        'In software development and online learning, mastering this requires:\n'
        '1. **Understanding the fundamentals**: Breaking down the concept into smaller building blocks.\n'
        '2. **Hands-on practice**: Experimenting in small code snippets or reviewing the course lessons.\n'
        '3. **Testing yourself**: Taking the module quiz to reinforce retention.\n\n'
        'Would you like me to generate a practice quiz or explain this with a code example?';
  }

  List<String> _getDynamicFollowUps(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('clean architecture')) {
      return const ['Show code example', 'How does Riverpod fit in?', 'Quiz me on architecture'];
    }
    if (lower.contains('spring boot')) {
      return const ['What about JWT tokens?', 'How to test endpoints?', 'Show Dio configuration'];
    }
    return const ['Explain more simply', 'Give me a quiz', 'Show code snippet'];
  }
}

final aiAssistantProvider = StateNotifierProvider<AiAssistantNotifier, AiAssistantState>((ref) {
  return AiAssistantNotifier();
});
