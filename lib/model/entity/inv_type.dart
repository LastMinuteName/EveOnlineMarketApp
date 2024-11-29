class InvType {
  final int typeID;
  final int groupID;
  final String typeName;
  final String description;
  final int? raceID;
  final int published;
  final int? marketGroupID;

  const InvType({
    required this.typeID,
    required this.groupID,
    required this.typeName,
    required this.description,
    required this.raceID,
    required this.published,
    required this.marketGroupID
  });
}