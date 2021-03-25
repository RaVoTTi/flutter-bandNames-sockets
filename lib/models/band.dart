class Band {

  String id;
  String name;
  int votes;

Band({ // Constructors
  this.id,
  this.name,
  this.votes = 0
});

factory Band.fromMap (Map<dynamic,dynamic> obj) =>  // propio de dart
  Band(
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  );




}


