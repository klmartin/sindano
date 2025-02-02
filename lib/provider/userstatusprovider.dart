import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserStatusProvider with ChangeNotifier {
  bool? _isAuthenticated;
  bool? _hasSubscription;
  String? _userId;

  bool? get isAuthenticated => _isAuthenticated;
  bool? get hasSubscription => _hasSubscription;
  String? get userId => _userId;

  Future<bool> _checkSubscription(userId) async {
    try {
      final String url = 'https://sindanoshow.com/public/api/payments/getSubscriptionStatus/$userId';

      print(url);

      print("status url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return data['isSubscribed'] ?? false;
      } else {
        debugPrint("Failed to fetch subscription: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error fetching subscription: $e");
      return false;
    }
  }

  Future<void> checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
      bool subscriptionStatus = await _checkSubscription(user?.uid);

    if (user != null) {
      _userId = user.uid;
      bool subscriptionStatus = await _checkSubscription(user.uid);

      print(subscriptionStatus);

      print('subscriptionStatus subscriptionStatus');

      _isAuthenticated = true;
      _hasSubscription = subscriptionStatus; // Set inside setState
      notifyListeners();

      print('hasSubscription: $hasSubscription'); // Debugging
    } else {
      _isAuthenticated = false;
      _hasSubscription = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> checkUserStatus2() async {
    User? user = FirebaseAuth.instance.currentUser;
      bool subscriptionStatus = await _checkSubscription(user?.uid);

    if (user != null) {
      _userId = user.uid;

 print(subscriptionStatus);

      print('subscriptionStatus subscriptionStatus');
      _isAuthenticated = true;
      _hasSubscription = subscriptionStatus; // Set inside setState
     
        notifyListeners();
      

      print('hasSubscription: $hasSubscription'); // Debugging

      // Return user data as JSON
      return {
        'userId': user.uid,
        'isAuthenticated': _isAuthenticated,
        'hasSubscription': _hasSubscription,
      };
    } else {
      _isAuthenticated = false;
      _hasSubscription = false;
        notifyListeners();

      // Return null if no user is authenticated
      return null;
    }
  }

  void setAuthenticationStatus(bool status) {
    _isAuthenticated = status;
    notifyListeners();
  }

  void setSubscriptionStatus(bool status) {
    _hasSubscription = status;
    notifyListeners();
  }
}
