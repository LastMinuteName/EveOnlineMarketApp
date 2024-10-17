/*
  This file contains an Enum that holds the region IDs of valid regions
  for market analysis for the market portion of the application
*/

enum Region {
  theForge(id: 10000002, name: "The Forge"),
  sinqLaison(id: 10000032, name: "Sinq Laison"),
  metropolis(id: 10000042, name: "Metropolis"),
  domain(id: 10000043, name: "Domain");


  const Region({required this.id, required this.name});

  final int id;
  final String name;
}