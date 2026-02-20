import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/animated_background.dart';
import '../widgets/gradient_button.dart';
import 'login_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  
  bool _isLoading = false;
  bool _saveCard = false;
  String _selectedPlan = 'monthly';
  
  final Map<String, Map<String, dynamic>> _plans = {
    'monthly': {
      'name': 'Monthly',
      'price': 9.99,
      'savings': 0,
      'popular': false,
    },
    'yearly': {
      'name': 'Yearly',
      'price': 99.99,
      'savings': 20,
      'popular': true,
    },
    'lifetime': {
      'name': 'Lifetime',
      'price': 199.99,
      'savings': 50,
      'popular': false,
    },
  };

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutQuint),
      ),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePayment() async {
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _showSuccessDialog();
      }
    }
  }

  bool _validateInputs() {
    if (_cardNumberController.text.length < 16) {
      _showSnackBar('Please enter a valid card number', isError: true);
      return false;
    }
    
    if (_cardHolderController.text.isEmpty) {
      _showSnackBar('Please enter card holder name', isError: true);
      return false;
    }
    
    if (_expiryDateController.text.length < 5) {
      _showSnackBar('Please enter valid expiry date (MM/YY)', isError: true);
      return false;
    }
    
    if (_cvvController.text.length < 3) {
      _showSnackBar('Please enter valid CVV', isError: true);
      return false;
    }
    
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B1E33),
                  Color(0xFF061016),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF67B26F),
                        Color(0xFF4A90E2),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.payment,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Success Title
                Text(
                  'Payment Successful!',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Payment Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Plan:',
                        '${_plans[_selectedPlan]!['name']} Plan',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Amount:',
                        '\$${_plans[_selectedPlan]!['price'].toStringAsFixed(2)}',
                      ),
                      if (_plans[_selectedPlan]!['savings'] > 0) ...[
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'You Save:',
                          '${_plans[_selectedPlan]!['savings']}%',
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'A confirmation email has been sent to your registered email address.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Go to Login Button
                GradientButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutQuint;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 800),
                      ),
                    );
                  },
                  child: const Text('Continue to Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red.shade900 : Colors.blue.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),

                  // Back button and header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Payment',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Main Content
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Pricing Plans
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Your Plan',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Plan options
                              ..._plans.entries.map((entry) {
                                return _buildPlanTile(entry.key, entry.value);
                              }).toList(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Payment Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.payment,
                                    color: Colors.blue.shade300,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Payment Details',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Card Number
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _cardNumberController,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 19,
                                  decoration: InputDecoration(
                                    labelText: 'Card Number',
                                    hintText: '1234 5678 9012 3456',
                                    labelStyle: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.white30,
                                      fontSize: 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.credit_card,
                                      color: Colors.blue.shade300,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    // Format card number with spaces
                                    if (value.length == 4 || value.length == 9 || value.length == 14) {
                                      _cardNumberController.text = '$value ';
                                      _cardNumberController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: _cardNumberController.text.length),
                                      );
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Card Holder
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _cardHolderController,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Card Holder Name',
                                    hintText: 'John Doe',
                                    labelStyle: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.white30,
                                      fontSize: 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.blue.shade300,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Expiry and CVV
                              Row(
                                children: [
                                  // Expiry Date
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _expiryDateController,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        keyboardType: TextInputType.datetime,
                                        maxLength: 5,
                                        decoration: InputDecoration(
                                          labelText: 'Expiry Date',
                                          hintText: 'MM/YY',
                                          labelStyle: GoogleFonts.montserrat(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          hintStyle: GoogleFonts.montserrat(
                                            color: Colors.white30,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.blue.shade300,
                                            size: 16,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          counterText: '',
                                        ),
                                        onChanged: (value) {
                                          // Auto-add slash after MM
                                          if (value.length == 2 && !value.contains('/')) {
                                            _expiryDateController.text = '$value/';
                                            _expiryDateController.selection = TextSelection.fromPosition(
                                              TextPosition(offset: _expiryDateController.text.length),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  // CVV
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _cvvController,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        maxLength: 4,
                                        decoration: InputDecoration(
                                          labelText: 'CVV',
                                          hintText: '123',
                                          labelStyle: GoogleFonts.montserrat(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          hintStyle: GoogleFonts.montserrat(
                                            color: Colors.white30,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.blue.shade300,
                                            size: 16,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Save card option
                              Row(
                                children: [
                                  Checkbox(
                                    value: _saveCard,
                                    onChanged: (value) {
                                      setState(() {
                                        _saveCard = value ?? false;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return const Color(0xFF4A90E2);
                                      }
                                      return Colors.white24;
                                    }),
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save card for future payments',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Order Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal:',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    '\$${_plans[_selectedPlan]!['price'].toStringAsFixed(2)}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (_plans[_selectedPlan]!['savings'] > 0) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Savings:',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                    Text(
                                      '-${_plans[_selectedPlan]!['savings']}%',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                  color: Colors.white24,
                                  height: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '\$${_plans[_selectedPlan]!['price'].toStringAsFixed(2)}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF4A90E2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Pay Now Button
                        GradientButton(
                          onPressed: _isLoading ? null : _handlePayment,
                          child: _isLoading
                              ? const SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Column(
                                  children: [
                                    const Text(
                                      'Pay Now',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '\$${_plans[_selectedPlan]!['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Secure payment note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.green.shade300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Secure payment powered by Stripe',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.green.shade300,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanTile(String planKey, Map<String, dynamic> plan) {
    final isSelected = _selectedPlan == planKey;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = planKey;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.blue.withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4A90E2) : Colors.white38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4A90E2),
                              Color(0xFF67B26F),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan['name'],
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.blue.shade300 : Colors.white,
                        ),
                      ),
                      if (plan['popular'])
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF67B26F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'POPULAR',
                            style: GoogleFonts.montserrat(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${plan['price'].toStringAsFixed(2)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.blue.shade300 : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Savings badge
            if (plan['savings'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Save ${plan['savings']}%',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade300,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}