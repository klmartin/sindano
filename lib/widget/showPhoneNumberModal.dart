import 'package:Sindano/provider/paymentprovider.dart';
import 'package:Sindano/provider/userstatusprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/country_code_helper.dart';
import '../webservices/apiservices.dart';

void showPhoneNumberModal(BuildContext context, amount, itemId, userId) {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = '+255';
  var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          return Consumer<PaymentProvider>(
              builder: (context, paymentProvider, _) {
            final userProvider = Provider.of<UserStatusProvider>(innerContext);

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Phone Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Country code selection
                      Container(
                        width: 140, // Adjust this width as per your design
                        child: DropdownButtonFormField<String>(
                          value: countryCode, // Use the countryCode variable
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            labelText: 'Code',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: CountryCodeHelper
                              .getCountryCodeDropdownItems(), // Use the helper class
                        ),
                      ),
                      SizedBox(
                          width:
                              10), // Spacing between country code and phone number field

                      // Phone number field
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.phone),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // Pay Button
                  ElevatedButton(
                    onPressed: () async {
                      String phoneNumber = phoneController.text.trim();
                      if (phoneNumber.isNotEmpty) {

                        paymentProvider.startPaying(phoneNumber,amount,itemId,userProvider.userId);

                        await ApiService()
                            .makePayment(userId, amount, phoneNumber, itemId);
                      } else {
                        // Show error if phone number is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a phone number')),
                        );
                      }
                    },
                    child: Text('Pay'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      );
    },
  ).then((result) {
    paymentProvider.paymentCanceled = true;
    print(paymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
}


