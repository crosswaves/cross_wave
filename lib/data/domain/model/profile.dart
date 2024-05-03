class Profile {
  String id;
  String? name;
  String? profilePicture;
  String membershipLevel;
  DateTime joinDate;
  String level;
  int weeklyProgress;
  int dailyProgress;
  int remainingChats;  // 채팅 잔여횟수

  Profile({
    this.id = '',
    this.name,
    this.profilePicture,
    required this.membershipLevel,
    required this.joinDate,
    required this.level,
    required this.weeklyProgress,
    required this.dailyProgress,
    required this.remainingChats,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? profilePicture,
    String? membershipLevel,
    DateTime? joinDate,
    String? level,
    int? weeklyProgress,
    int? dailyProgress,
    int? remainingChats,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      joinDate: joinDate ?? this.joinDate,
      level: level ?? this.level,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      remainingChats: remainingChats ?? this.remainingChats,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name ?? 'Default Name',
    'profilePicture': profilePicture ?? 'Default Picture',
    'membershipLevel': membershipLevel,
    'joinDate': joinDate.toIso8601String(),
    'level': level,
    'weeklyProgress': weeklyProgress,
    'dailyProgress': dailyProgress,
    'remainingChats': remainingChats,
  };

  static Profile fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    name: json['name'],
    profilePicture: json['profilePicture'],
    membershipLevel: json['membershipLevel'],
    joinDate: DateTime.parse(json['joinDate']),
    level: json['level'],
    weeklyProgress: json['weeklyProgress'],
    dailyProgress: json['dailyProgress'],
    remainingChats: json['remainingChats'] ?? 0,
  );
}