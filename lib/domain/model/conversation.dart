import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Conversation {
  final String id;
  final String message;
  final bool isMe;
  final Timestamp timestamp;

  const Conversation({
    required this.id,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });
}