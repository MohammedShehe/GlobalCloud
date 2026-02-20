import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/animated_background.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _familyPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Family members list
  final List<FamilyMember> _familyMembers = [];
  
  // Current member being added
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _thirdNameController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  int? _selectedAdminIndex;

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
    
    // Add the first member (admin will be selected from list)
    _addEmptyMember();
  }

  void _addEmptyMember() {
    if (_familyMembers.length < 10) {
      setState(() {
        _familyMembers.add(FamilyMember(
          firstName: '',
          secondName: '',
          thirdName: '',
        ));
      });
    }
  }

  void _addMember() {
    if (_familyMembers.length >= 10) {
      _showSnackBar('Maximum 10 family members allowed', isError: true);
      return;
    }

    if (_firstNameController.text.isEmpty ||
        _secondNameController.text.isEmpty ||
        _thirdNameController.text.isEmpty) {
      _showSnackBar('Please fill in all name fields', isError: true);
      return;
    }

    // Check for duplicate names
    bool isDuplicate = _familyMembers.any((member) =>
        member.firstName == _firstNameController.text &&
        member.secondName == _secondNameController.text &&
        member.thirdName == _thirdNameController.text);

    if (isDuplicate) {
      _showSnackBar('This family member already exists', isError: true);
      return;
    }

    setState(() {
      _familyMembers.add(FamilyMember(
        firstName: _firstNameController.text,
        secondName: _secondNameController.text,
        thirdName: _thirdNameController.text,
      ));
      
      // Clear controllers
      _firstNameController.clear();
      _secondNameController.clear();
      _thirdNameController.clear();
    });

    _showSnackBar('Family member added successfully');
  }

  void _removeMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
      // If removed member was admin, clear admin selection
      if (_selectedAdminIndex == index) {
        _selectedAdminIndex = null;
      } else if (_selectedAdminIndex != null && _selectedAdminIndex! > index) {
        _selectedAdminIndex = _selectedAdminIndex! - 1;
      }
    });
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_familyMembers.isEmpty) {
      _showSnackBar('Please add at least one family member', isError: true);
      return;
    }

    if (_selectedAdminIndex == null) {
      _showSnackBar('Please select an admin for the family', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate registration delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog();
    }
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4A90E2),
                        Color(0xFF67B26F),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Registration Successful!',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your family has been registered successfully.\n\n'
                  'Family Name: ${_familyNameController.text}\n'
                  'Total Members: ${_familyMembers.length}\n'
                  'Admin: ${_familyMembers[_selectedAdminIndex!].fullName}\n\n'
                  'All family members can now sign in using their full name '
                  '(First, Second, Third) and the family password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
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
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        );
      },
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
  void dispose() {
    _controller.dispose();
    _familyNameController.dispose();
    _familyPasswordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    super.dispose();
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
                          'Family Registration',
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

                  // Form
                  SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Family Name
                          CustomTextField(
                            controller: _familyNameController,
                            label: 'Family Name',
                            hint: 'Enter your family name',
                            prefixIcon: Icons.family_restroom,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter family name';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 20),

                          // Family Password
                          CustomTextField(
                            controller: _familyPasswordController,
                            label: 'Family Password',
                            hint: 'Create a family password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),

                          // Confirm Password
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Re-enter family password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm password';
                              }
                              if (value != _familyPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Add Family Members Section
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
                                      Icons.people,
                                      color: Colors.blue.shade300,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add Family Members',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 8),
                                
                                Text(
                                  'Add up to 10 family members. Each member will use their full name '
                                  '(First, Second, Third) and the family password to sign in.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white60,
                                    height: 1.4,
                                  ),
                                ),
                                
                                const SizedBox(height: 16),

                                // Input fields for new member
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _firstNameController,
                                        label: 'First',
                                        hint: 'First name',
                                        validator: (value) => null, // Optional for partial input
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _secondNameController,
                                        label: 'Second',
                                        hint: 'Second name',
                                        validator: (value) => null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _thirdNameController,
                                        label: 'Third',
                                        hint: 'Third name',
                                        validator: (value) => null,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Add member button
                                GradientButton(
                                  onPressed: _familyMembers.length >= 10 ? null : _addMember,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Add Member (${_familyMembers.length}/10)',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Family Members List
                          if (_familyMembers.isNotEmpty) ...[
                            Text(
                              'Family Members List',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Members list
                            ...List.generate(_familyMembers.length, (index) {
                              final member = _familyMembers[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedAdminIndex == index
                                        ? const Color(0xFF4A90E2)
                                        : Colors.white.withOpacity(0.1),
                                    width: _selectedAdminIndex == index ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Admin indicator
                                    if (_selectedAdminIndex == index)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF4A90E2),
                                              Color(0xFF67B26F),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'ADMIN',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.fullName,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (member.firstName.isEmpty ||
                                              member.secondName.isEmpty ||
                                              member.thirdName.isEmpty)
                                            Text(
                                              'Incomplete profile',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                color: Colors.orange.shade300,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Make Admin button
                                    if (_selectedAdminIndex != index)
                                      IconButton(
                                        icon: Icon(
                                          Icons.admin_panel_settings,
                                          color: Colors.blue.shade300,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedAdminIndex = index;
                                          });
                                          _showSnackBar(
                                              '${member.fullName} is now the family admin');
                                        },
                                      ),
                                    
                                    // Remove member button
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red.shade300,
                                        size: 20,
                                      ),
                                      onPressed: () => _removeMember(index),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            
                            const SizedBox(height: 16),
                          ],

                          // Important Notes Section
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.blue.shade300,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Important Information',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildInfoBullet(
                                  'All family members use the SAME family password to sign in',
                                ),
                                _buildInfoBullet(
                                  'Each member signs in using their FULL NAME (First, Second, Third)',
                                ),
                                _buildInfoBullet(
                                  'The Admin can manage family settings:',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24, top: 4),
                                  child: Column(
                                    children: [
                                      _buildSubInfoBullet('Add or remove family members'),
                                      _buildSubInfoBullet('Change family password'),
                                      _buildSubInfoBullet('Update family name'),
                                      _buildSubInfoBullet('Manage member permissions'),
                                    ],
                                  ),
                                ),
                                _buildInfoBullet(
                                  'Maximum 10 family members per family',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Register button
                          GradientButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : const Text(
                                    'Register Family',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
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

  Widget _buildInfoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubInfoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Text(
            '  - ',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyMember {
  String firstName;
  String secondName;
  String thirdName;

  FamilyMember({
    required this.firstName,
    required this.secondName,
    required this.thirdName,
  });

  String get fullName => '$firstName $secondName $thirdName';
}