class DashboardResponse {
  final Event? event;
  final User? user;
  final List<Announcement> announcements;

  DashboardResponse({this.event, this.user, required this.announcements});

  factory DashboardResponse.fromJson(Map<String, dynamic>? json) {
    final data = json?['data'];

    return DashboardResponse(
      event: data?['event'] != null ? Event.fromJson(data['event']) : null,
      user: data?['user'] != null ? User.fromJson(data['user']) : null,
      announcements: (data?['announcements'] as List? ?? [])
          .map((e) => Announcement.fromJson(e))
          .toList(),
    );
  }
}

class Event {
  final String id;
  final String name;
  final Location? location;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> instructions;
  final List<Included> included;

  Event({
    required this.id,
    required this.name,
    this.location,
    this.date,
    this.startTime,
    this.endTime,
    required this.instructions,
    required this.included,
  });

  factory Event.fromJson(Map<String, dynamic>? json) {
    return Event(
      id: json?['_id'] ?? '',
      name: json?['name'] ?? '',
      location: json?['location'] != null
          ? Location.fromJson(json?['location'])
          : null,
      date: json?['date'] != null ? DateTime.tryParse(json!['date']) : null,
      startTime: json?['startTime'] != null
          ? DateTime.tryParse(json!['startTime'])
          : null,
      endTime: json?['endTime'] != null
          ? DateTime.tryParse(json!['endTime'])
          : null,
      instructions: List<String>.from(json?['instructions'] ?? []),
      included: (json?['included'] as List? ?? [])
          .map((e) => Included.fromJson(e))
          .toList(),
    );
  }
}

class Location {
  final String venue;
  final String address;
  final String mapLink;

  Location({required this.venue, required this.address, required this.mapLink});

  factory Location.fromJson(Map<String, dynamic>? json) {
    return Location(
      venue: json?['venue'] ?? '',
      address: json?['address'] ?? '',
      mapLink: json?['mapLink'] ?? '',
    );
  }
}

class Included {
  final String title;
  final String image;

  Included({required this.title, required this.image});

  factory Included.fromJson(Map<String, dynamic>? json) {
    return Included(title: json?['title'] ?? '', image: json?['image'] ?? '');
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String role;
  final String status;
  final String section;
  final String seat;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
    required this.status,
    required this.section,
    required this.seat,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
      id: json?['_id'] ?? '',
      name: json?['name'] ?? '',
      email: json?['email'] ?? '',
      image: json?['image'] ?? '',
      role: json?['role'] ?? '',
      status: json?['status'] ?? '',
      section: json?['section'] ?? '',
      seat: json?['seat'] ?? 'N/A',
    );
  }
}

class Announcement {
  final String id;
  final String title;
  final String description;
  final String createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic>? json) {
    return Announcement(
      id: json?['_id'] ?? '',
      title: json?['title'] ?? '',
      description: json?['description'] ?? '',
      createdAt: json?['createdAt'] ?? '',
    );
  }
}
