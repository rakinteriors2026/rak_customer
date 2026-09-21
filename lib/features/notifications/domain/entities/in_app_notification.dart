class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.targetType,
    required this.targetId,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String targetType;
  final String targetId;
  final bool read;
  final DateTime createdAt;

  bool get hasTarget => targetType != 'none' && targetId.isNotEmpty;

  InAppNotification copyWith({bool? read}) {
    return InAppNotification(
      id: id,
      title: title,
      body: body,
      targetType: targetType,
      targetId: targetId,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }
}

class DeviceRegistration {
  const DeviceRegistration({
    required this.id,
    required this.accountId,
    required this.platform,
    required this.installationId,
    this.pushToken,
  });

  final String id;
  final String accountId;
  final String platform;
  final String installationId;
  final String? pushToken;
}

class DeviceIdentity {
  const DeviceIdentity({
    required this.platform,
    required this.installationId,
    this.pushToken,
    this.pushPermissionGranted = false,
  });

  final String platform;
  final String installationId;
  final String? pushToken;
  final bool pushPermissionGranted;
}

sealed class NotificationDestination {
  const NotificationDestination();
}

class NotificationDestinationNone extends NotificationDestination {
  const NotificationDestinationNone();
}

class NotificationDestinationProject extends NotificationDestination {
  const NotificationDestinationProject(this.projectId);
  final String projectId;
}

class NotificationDestinationDenied extends NotificationDestination {
  const NotificationDestinationDenied();
}
