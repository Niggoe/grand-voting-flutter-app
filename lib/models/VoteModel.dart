class VoteModel {
  String? accessCode;
  String? owner;
  String? description;
  bool? closed;
  String? title;
  String? startTime;
  String? endTime;
  String? id;

  VoteModel(
      {this.accessCode,
      this.owner,
      this.title,
      this.description,
      this.closed,
      this.startTime,
      this.endTime});
}
