class NameAndLanguage {
  NameAndLanguage({
    required this.name,
    required this.language,
  });
  String name;
  String language;

  factory NameAndLanguage.fromJson(Map<String, dynamic> json) =>
      NameAndLanguage(
        name: json['name'] as String,
        language: json['language'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'language': language,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAndLanguage &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          language == other.language;

  @override
  int get hashCode => name.hashCode ^ language.hashCode;

  @override
  String toString() {
    return 'NameAndLanguage{name: $name, language: $language}';
  }
}
