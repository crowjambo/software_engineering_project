import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/models/message_model.dart';

//init message
Message initMessage = Message(currentUser, "toUUID", "0", "Init");

//user UUID and username
User currentUser;

// constants
const double kDefaultPadding = 16.0;
const double kDefaultHeaderSize = 22.0;

const Color kThemeColor = Colors.blue;
const Color kAccentColor = Colors.white70;
const Color kAccentBlack = Colors.black54;

// filenames
const String kContactListJson = 'contacts.json';
const String kActiveChatsJson = 'chats/activeChats.json';

//dirs
const String kChatDir = 'chats/';
const String kMessageFile = "/messages.json";
