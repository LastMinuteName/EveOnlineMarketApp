import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

Image fetchMarketGroupIcon(int id) {
  String iconPath = join("assets", "icons/invMarketGroupsIcons/$id.png");
  return Image.asset(iconPath, fit: BoxFit.cover, errorBuilder: (ctx, error, stackTrace) => Image.asset(join("assets", "icons/invMarketGroupsIcons/0.png")));
}

Image fetchInvTypeIcon(int id) {
  String iconPath = join("assets", "icons/invTypeIcons/$id.png");
  return Image.asset(iconPath, fit: BoxFit.cover, errorBuilder: (ctx, error, stackTrace) => Image.asset(join("assets", "icons/invTypeIcons/0.png")));
}