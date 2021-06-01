class StepWorkout {
  String duration;
  String imageUrl;
  String message;
  String reps;
  String type;

  StepWorkout({
    this.duration,
    this.imageUrl,
    this.message,
    this.reps,
    this.type,
  });

  factory StepWorkout.fromDocument(dynamic doc) {
    return StepWorkout(
      duration: doc['duration'],
      imageUrl: doc['image_url'],
      message: doc['message'],
      reps: doc['reps'],
      type: doc['type'],
    );
  }
}