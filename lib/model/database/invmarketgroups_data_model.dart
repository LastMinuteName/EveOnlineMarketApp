class InvMarketGroups {
  final int marketGroupID;
  final int parentGroupID;
  final String marketGroupName;
  final String description;
  final int iconID;
  final bool hasTypes;

  const InvMarketGroups({
    required this.marketGroupID,
    required this.parentGroupID,
    required this.marketGroupName,
    required this.description,
    required this.iconID,
    required this.hasTypes,
  });
}