class MapRegion {
  final int regionID;
  final String regionName;
  final int? factionID;
  final int nebula;

  const MapRegion({
    required this.regionID,
    required this.regionName,
    this.factionID,
    required this.nebula
  });
}