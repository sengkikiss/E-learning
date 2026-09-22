import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_learning/features/ai_assistant/presentation/providers/ai_assistant_providers.dart';

void main() {
  group('AiAssistantNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has welcome message and suggested prompts', () {
      final state = container.read(aiAssistantProvider);
      expect(state.messages, isNotEmpty);
      expect(state.messages.first.isUser, isFalse);
      expect(state.messages.first.suggestedPrompts, isNotEmpty);
      expect(state.isTyping, isFalse);
    });

    test('sendMessage appends user message and simulates smart AI reply', () async {
      final notifier = container.read(aiAssistantProvider.notifier);
      await notifier.sendMessage('Explain Clean Architecture');

      final state = container.read(aiAssistantProvider);
      expect(state.messages.length, greaterThanOrEqualTo(3));

      // Check user message
      final userMsg = state.messages[1];
      expect(userMsg.isUser, isTrue);
      expect(userMsg.text, 'Explain Clean Architecture');

      // Check AI response
      final aiMsg = state.messages[2];
      expect(aiMsg.isUser, isFalse);
      expect(aiMsg.text.contains('Clean Architecture'), isTrue);
      expect(aiMsg.text.contains('Presentation Layer'), isTrue);
      expect(state.isTyping, isFalse);
    });

    test('clearConversation resets chat to initial clean state', () async {
      final notifier = container.read(aiAssistantProvider.notifier);
      await notifier.sendMessage('Hello');
      notifier.clearConversation();

      final state = container.read(aiAssistantProvider);
      expect(state.messages.length, 1);
      expect(state.messages.first.text.contains('cleared'), isTrue);
    });
  });
}
