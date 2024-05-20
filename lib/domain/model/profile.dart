class Profile {
  String id;
  String? name;
  String? profilePicture;
  String membershipLevel;
  DateTime? joinDate;
  String level;
  int weeklyProgress;
  int dailyProgress;
  int remainingChats;
  int maxChats;
  String? email;  // 추가된 이메일 필드
  DateTime? lastSignInTime;  // 추가된 마지막 로그인 시간 필드
  List<String>? theme;

  Profile({
    this.id = '',
    required this.name,
    required this.profilePicture,
    required this.membershipLevel,
    required this.joinDate,
    required this.level,
    required this.weeklyProgress,
    required this.dailyProgress,
    required this.remainingChats,
    required this.maxChats,
    required this.email,  // 생성자에 이메일 추가
    required this.lastSignInTime,  // 생성자에 마지막 로그인 시간 추가
    required this.theme,
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
    int? maxChats,
    String? email,
    DateTime? lastSignInTime,
    List<String>? theme,
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
      maxChats: maxChats ?? this.maxChats,
      email: email ?? this.email,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name ?? 'Default Name',
    'profilePicture': profilePicture ?? 'Default Picture',
    'membershipLevel': membershipLevel,
    'joinDate': joinDate?.toIso8601String(),
    'level': level,
    'weeklyProgress': weeklyProgress,
    'dailyProgress': dailyProgress,
    'remainingChats': remainingChats,
    'email': email,  // JSON 변환 시 이메일 추가
    'lastSignInTime': lastSignInTime?.toIso8601String(),  // JSON 변환 시 마지막 로그인 시간 추가
    'theme': theme ?? [],
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
    maxChats: json['remainingChats'] ?? 0,
    email: json['email'],  // JSON으로부터 이메일 파싱
    lastSignInTime: json['lastSignInTime'] != null ? DateTime.parse(json['lastSignInTime']) : null,  // JSON으로부터 마지막 로그인 시간 파싱
    theme: List<String>.from(json['theme'] ?? []),
  );
}