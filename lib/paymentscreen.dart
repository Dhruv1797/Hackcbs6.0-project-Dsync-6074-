import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _razorpay = Razorpay();

  // Initialize Razorpay with your key ID and a callback function
  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _startPayment() async {
    var options = {
      'key': 'rzp_test_2OQh5hsxIDa0Gp',
      'amount':
          100, // Amount in smallest currency unit (e.g., 1000 = 10.00 INR)
      'name': 'MOVEEASY',
      'description': 'Payment for your service',
      'prefill': {
        'contact': '9084773324',
        'email': 'dhruvrastogi1797@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment success: ${response.paymentId}  ${response.orderId} ');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  @override
  void initState() {
    super.initState();

    // Call _initializeRazorpay function to set up event listeners
    _initializeRazorpay();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the _startPayment function when the button is tapped
            _startPayment();
          },
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}
