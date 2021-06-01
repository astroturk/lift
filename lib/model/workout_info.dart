class WorkoutInfo {
  final String totalTime;
  final String description;
  final String thumbnailUrl;
  final String title;
  final String workoutId;
  final String ownerId;
  final steps;

  WorkoutInfo({
    this.totalTime,
    this.description,
    this.thumbnailUrl,
    this.title,
    this.workoutId,
    this.ownerId,
    this.steps,
  });

  factory WorkoutInfo.fromDocument(dynamic doc){
    return WorkoutInfo(
      totalTime: doc['completion_time'],
      description: doc['description'],
      thumbnailUrl: doc['thumbnail_url'],
      title: doc['title'],
      workoutId: doc['workout_id'],
      ownerId: doc['owner_id'],
      steps: doc['steps_data'],
    );
  }
}
