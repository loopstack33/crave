
// ignore_for_file: file_names

class User {
  final int id;
  final String name;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class Message {
  final User sender;
  final String
  time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Stella',
  imageUrl: 'assets/images/Photo.png',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Kate',
  imageUrl: 'assets/images/Photo-1.png',
);
final User james = User(
  id: 2,
  name: 'Jessi',
  imageUrl: 'assets/images/Photo-2.png',
);
final User john = User(
  id: 3,
  name: 'Mary',
  imageUrl: 'assets/images/Photo-3.png',
);
final User olivia = User(
  id: 4,
  name: 'Mona',
  imageUrl: 'assets/images/Photo-4.png',
);


// FAVORITE CONTACTS
List<User> favorites = [currentUser,james, olivia, john, greg];
