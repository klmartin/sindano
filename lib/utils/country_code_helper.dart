import 'package:flutter/material.dart';

class CountryCodeHelper {
  // Method to return a list of country codes as DropdownMenuItem<String>
  static List<DropdownMenuItem<String>> getCountryCodeDropdownItems() {
    // List<Map<String, String>> countryCodes = [
    //   {"code": "+1", "name": "USA"},
    //   {"code": "+44", "name": "UK"},
    //   {"code": "+91", "name": "India"},
    //   {"code": "+61", "name": "Australia"},
    //   {"code": "+81", "name": "Japan"},
    //   {"code": "+49", "name": "Germany"},
    //   {"code": "+33", "name": "France"},
    //   {"code": "+86", "name": "China"},
    //   {"code": "+7", "name": "Russia"},
    //   {"code": "+39", "name": "Italy"},
    //   // Add more country codes as needed
    // ];
    List<Map<String, String>> countryCodes = [
      {
        "name": "Tanzania",
        "code": "TZ",
        "emoji": "🇹🇿",
        "unicode": "U+1F1F9 U+1F1FF",
        "image": "TZ.svg",
        "dial_code": "+255"
      }
    ];

    return countryCodes
        .map((country) => DropdownMenuItem<String>(
      value: country["dial_code"],
      child: Text("${country["dial_code"]} (${country["emoji"]})"),
    ))
        .toList();
  }
}
