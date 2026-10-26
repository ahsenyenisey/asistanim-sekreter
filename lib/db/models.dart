/// SQLite tablolarına karşılık gelen veri modelleri.
/// Tarihler ISO-8601 string olarak saklanır (yerel saat dilimi offset'i dahil).
library;

class Note {
  final int id;
  final String title;
  final String content;
  final String? imageUri;
  final bool pinned;
  final String createdAt;
  final String updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUri,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, Object?> m) => Note(
        id: m['id'] as int,
        title: m['title'] as String,
        content: m['content'] as String? ?? '',
        imageUri: m['image_uri'] as String?,
        pinned: (m['pinned'] as int? ?? 0) == 1,
        createdAt: m['created_at'] as String,
        updatedAt: m['updated_at'] as String,
      );
}

class Reminder {
  final int id;
  final String title;
  final String body;
  final String dueAt;
  final String? notificationId;
  final bool done;
  final String createdAt;

  const Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.dueAt,
    required this.notificationId,
    required this.done,
    required this.createdAt,
  });

  factory Reminder.fromMap(Map<String, Object?> m) => Reminder(
        id: m['id'] as int,
        title: m['title'] as String,
        body: m['body'] as String? ?? '',
        dueAt: m['due_at'] as String,
        notificationId: m['notification_id'] as String?,
        done: (m['done'] as int? ?? 0) == 1,
        createdAt: m['created_at'] as String,
      );
}

enum ProcessStatus { active, done, archived }

ProcessStatus processStatusFromString(String s) {
  return ProcessStatus.values.firstWhere((e) => e.name == s, orElse: () => ProcessStatus.active);
}

class ProcessItem {
  final int id;
  final String title;
  final String description;
  final ProcessStatus status;
  final String createdAt;
  final String updatedAt;
  final int totalSteps;
  final int doneSteps;

  const ProcessItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.totalSteps = 0,
    this.doneSteps = 0,
  });

  factory ProcessItem.fromMap(Map<String, Object?> m) => ProcessItem(
        id: m['id'] as int,
        title: m['title'] as String,
        description: m['description'] as String? ?? '',
        status: processStatusFromString(m['status'] as String? ?? 'active'),
        createdAt: m['created_at'] as String,
        updatedAt: m['updated_at'] as String,
        totalSteps: (m['total_steps'] as int?) ?? 0,
        doneSteps: (m['done_steps'] as int?) ?? 0,
      );
}

class ProcessStep {
  final int id;
  final int processId;
  final String title;
  final int position;
  final bool done;

  const ProcessStep({
    required this.id,
    required this.processId,
    required this.title,
    required this.position,
    required this.done,
  });

  factory ProcessStep.fromMap(Map<String, Object?> m) => ProcessStep(
        id: m['id'] as int,
        processId: m['process_id'] as int,
        title: m['title'] as String,
        position: m['position'] as int,
        done: (m['done'] as int? ?? 0) == 1,
      );
}

enum ChatRole { user, assistant }

class ChatMessage {
  final int id;
  final ChatRole role;
  final String content;
  final String createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, Object?> m) => ChatMessage(
        id: m['id'] as int,
        role: (m['role'] as String) == 'user' ? ChatRole.user : ChatRole.assistant,
        content: m['content'] as String,
        createdAt: m['created_at'] as String,
      );
}
