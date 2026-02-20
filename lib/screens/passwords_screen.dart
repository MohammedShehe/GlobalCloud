import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<PasswordItem> _allPasswords = [];
  List<PasswordItem> _filteredPasswords = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Favorites', 'Social', 'Finance', 'Work', 'Shopping'];
  
  // Track which passwords are visible
  final Set<String> _visiblePasswords = {};

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    
    _controller.forward();
    
    // Load mock passwords
    _loadPasswords();
    
    _searchController.addListener(_filterPasswords);
  }

  void _loadPasswords() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allPasswords.addAll([
          PasswordItem(
            id: '1',
            title: 'Gmail',
            username: 'john.doe@gmail.com',
            password: 'P@ssw0rd123!',
            url: 'https://mail.google.com',
            category: 'Social',
            notes: 'Primary email account',
            modified: 'Today, 10:30 AM',
            modifiedBy: 'John Doe',
            icon: Icons.email,
            color: Colors.red,
            isFavorite: true,
            strength: PasswordStrength.strong,
            lastUsed: 'Today',
            expiryDays: 30,
          ),
          PasswordItem(
            id: '2',
            title: 'Facebook',
            username: 'john.doe',
            password: 'F@ceb00k456!',
            url: 'https://facebook.com',
            category: 'Social',
            notes: 'Personal Facebook account',
            modified: 'Yesterday, 3:45 PM',
            modifiedBy: 'John Doe',
            icon: Icons.facebook,
            color: Colors.blue,
            isFavorite: false,
            strength: PasswordStrength.medium,
            lastUsed: '2 days ago',
            expiryDays: 15,
          ),
          PasswordItem(
            id: '3',
            title: 'Bank of America',
            username: 'john_doe',
            password: 'B@nk!ng789@',
            url: 'https://bankofamerica.com',
            category: 'Finance',
            notes: 'Checking account',
            modified: 'Dec 25, 2024',
            modifiedBy: 'Admin',
            icon: Icons.account_balance,
            color: Colors.green,
            isFavorite: true,
            strength: PasswordStrength.strong,
            lastUsed: 'Dec 24, 2024',
            expiryDays: 60,
          ),
          PasswordItem(
            id: '4',
            title: 'Amazon',
            username: 'john.doe@email.com',
            password: 'Am@z0nPrime!23',
            url: 'https://amazon.com',
            category: 'Shopping',
            notes: 'Prime account',
            modified: 'Dec 20, 2024',
            modifiedBy: 'Sarah Smith',
            icon: Icons.shopping_cart,
            color: Colors.orange,
            isFavorite: false,
            strength: PasswordStrength.medium,
            lastUsed: 'Dec 19, 2024',
            expiryDays: 45,
          ),
          PasswordItem(
            id: '5',
            title: 'Work VPN',
            username: 'jdoe@company.com',
            password: 'VPN@c0mpany!',
            url: 'vpn.company.com',
            category: 'Work',
            notes: 'Corporate VPN access',
            modified: 'Dec 15, 2024',
            modifiedBy: 'IT Admin',
            icon: Icons.vpn_key,
            color: Colors.purple,
            isFavorite: true,
            strength: PasswordStrength.strong,
            lastUsed: 'Dec 15, 2024',
            expiryDays: 90,
          ),
          PasswordItem(
            id: '6',
            title: 'Netflix',
            username: 'family@email.com',
            password: 'N3tfl!x2024',
            url: 'https://netflix.com',
            category: 'Entertainment',
            notes: 'Family account',
            modified: 'Dec 10, 2024',
            modifiedBy: 'Admin',
            icon: Icons.movie,
            color: Colors.red,
            isFavorite: false,
            strength: PasswordStrength.weak,
            lastUsed: 'Today',
            expiryDays: 5,
          ),
          PasswordItem(
            id: '7',
            title: 'Dropbox',
            username: 'john.doe@email.com',
            password: 'Dr0pB0x!456',
            url: 'https://dropbox.com',
            category: 'Work',
            notes: 'Work files backup',
            modified: 'Dec 5, 2024',
            modifiedBy: 'John Doe',
            icon: Icons.cloud,
            color: Colors.blue,
            isFavorite: false,
            strength: PasswordStrength.medium,
            lastUsed: 'Dec 3, 2024',
            expiryDays: 20,
          ),
          PasswordItem(
            id: '8',
            title: 'Instagram',
            username: 'john_photos',
            password: 'Inst@gr@m789',
            url: 'https://instagram.com',
            category: 'Social',
            notes: 'Personal photos',
            modified: 'Nov 28, 2024',
            modifiedBy: 'John Doe',
            icon: Icons.photo_camera,
            color: Colors.purple,
            isFavorite: true,
            strength: PasswordStrength.weak,
            lastUsed: 'Nov 27, 2024',
            expiryDays: 10,
          ),
          PasswordItem(
            id: '9',
            title: 'PayPal',
            username: 'john.doe@email.com',
            password: 'P@yP@l!5678',
            url: 'https://paypal.com',
            category: 'Finance',
            notes: 'Online payments',
            modified: 'Nov 20, 2024',
            modifiedBy: 'Admin',
            icon: Icons.payment,
            color: Colors.blue,
            isFavorite: true,
            strength: PasswordStrength.strong,
            lastUsed: 'Nov 18, 2024',
            expiryDays: 30,
          ),
          PasswordItem(
            id: '10',
            title: 'Spotify',
            username: 'family.music',
            password: 'Sp0t!fy2024',
            url: 'https://spotify.com',
            category: 'Entertainment',
            notes: 'Family music subscription',
            modified: 'Nov 15, 2024',
            modifiedBy: 'Sarah Smith',
            icon: Icons.music_note,
            color: Colors.green,
            isFavorite: false,
            strength: PasswordStrength.medium,
            lastUsed: 'Yesterday',
            expiryDays: 25,
          ),
        ]);
        
        _filteredPasswords = _allPasswords;
        _isLoading = false;
      });
    });
  }

  void _filterPasswords() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPasswords = _allPasswords.where((item) {
        return item.title.toLowerCase().contains(query) ||
               item.username.toLowerCase().contains(query) ||
               item.category.toLowerCase().contains(query) ||
               (item.url?.toLowerCase().contains(query) ?? false) ||
               (item.notes?.toLowerCase().contains(query) ?? false);
      }).toList();
      
      // Apply category filter
      if (_selectedFilter != 'All') {
        _filteredPasswords = _filteredPasswords.where((item) {
          if (_selectedFilter == 'Favorites') {
            return item.isFavorite;
          }
          return item.category == _selectedFilter;
        }).toList();
      }
    });
  }

  void _showAddPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: const AddPasswordDialog(),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _addNewPassword(value);
      }
    });
  }

  void _addNewPassword(Map<String, dynamic> data) {
    setState(() {
      final newPassword = PasswordItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['title'],
        username: data['username'],
        password: data['password'],
        url: data['url'],
        category: data['category'],
        notes: data['notes'],
        modified: 'Just now',
        modifiedBy: 'Current User', // Replace with actual user
        icon: _getIconForCategory(data['category']),
        color: _getColorForCategory(data['category']),
        isFavorite: data['isFavorite'] ?? false,
        strength: _calculatePasswordStrength(data['password']),
        lastUsed: 'Never',
        expiryDays: data['expiryDays'] ?? 90,
      );
      
      _allPasswords.insert(0, newPassword);
      _filterPasswords();
    });

    _showSnackBar('Password added successfully', isError: false);
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Social':
        return Icons.people;
      case 'Finance':
        return Icons.account_balance;
      case 'Work':
        return Icons.work;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.lock;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Social':
        return Colors.blue;
      case 'Finance':
        return Colors.green;
      case 'Work':
        return Colors.purple;
      case 'Shopping':
        return Colors.orange;
      case 'Entertainment':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.length < 6) {
      return PasswordStrength.weak;
    }
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int strength = 0;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecial) strength++;
    
    if (strength <= 2) return PasswordStrength.weak;
    if (strength == 3) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  void _togglePasswordVisibility(String id) {
    setState(() {
      if (_visiblePasswords.contains(id)) {
        _visiblePasswords.remove(id);
      } else {
        _visiblePasswords.add(id);
      }
    });
  }

  void _copyToClipboard(String text, String label) {
    // In a real app, you would use Clipboard.setData
    _showSnackBar('$label copied to clipboard', isError: false);
  }

  void _showPasswordOptions(PasswordItem password) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1E33),
              Color(0xFF061016),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: password.color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            password.icon,
                            color: password.color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                password.title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                password.category,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: password.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Password details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildPasswordDetailRow(
                            'Username',
                            password.username,
                            Icons.person,
                            () => _copyToClipboard(password.username, 'Username'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                          _buildPasswordDetailRow(
                            'Password',
                            _visiblePasswords.contains(password.id) 
                                ? password.password 
                                : '••••••••••••',
                            Icons.lock,
                            () => _togglePasswordVisibility(password.id),
                            isPassword: true,
                            actionIcon: _visiblePasswords.contains(password.id)
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          if (password.url != null && password.url!.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: Colors.white24, height: 1),
                            ),
                            _buildPasswordDetailRow(
                              'URL',
                              password.url!,
                              Icons.link,
                              () => _copyToClipboard(password.url!, 'URL'),
                            ),
                          ],
                          if (password.notes != null && password.notes!.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: Colors.white24, height: 1),
                            ),
                            _buildPasswordDetailRow(
                              'Notes',
                              password.notes!,
                              Icons.note,
                              () => _copyToClipboard(password.notes!, 'Notes'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Password strength and expiry
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getStrengthColor(password.strength).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: _getStrengthColor(password.strength),
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Strength',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  password.strength.toString().split('.').last,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStrengthColor(password.strength),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: password.expiryDays < 30
                                  ? Colors.orange.withOpacity(0.15)
                                  : Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: password.expiryDays < 30
                                      ? Colors.orange
                                      : Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Expires in',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  '${password.expiryDays} days',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: password.expiryDays < 30
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPasswordActionButton(
                          icon: Icons.edit,
                          label: 'Edit',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _showEditPasswordDialog(password);
                          },
                        ),
                        _buildPasswordActionButton(
                          icon: Icons.favorite,
                          label: password.isFavorite ? 'Unfavorite' : 'Favorite',
                          color: Colors.red,
                          onTap: () {
                            setState(() {
                              password.isFavorite = !password.isFavorite;
                            });
                            Navigator.pop(context);
                            _showSnackBar(
                              password.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                              isError: false,
                            );
                          },
                        ),
                        _buildPasswordActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showSharePasswordDialog(password);
                          },
                        ),
                        _buildPasswordActionButton(
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(password);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Last used info
                    Text(
                      'Last used: ${password.lastUsed}',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordDetailRow(
    String label,
    String value,
    IconData icon,
    VoidCallback onTap, {
    bool isPassword = false,
    IconData? actionIcon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.blue.shade300,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: isPassword ? FontWeight.w500 : FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: isPassword ? 1 : 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            actionIcon ?? Icons.copy,
            size: 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPasswordDialog(PasswordItem password) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: EditPasswordDialog(password: password),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _updatePassword(password.id, value);
      }
    });
  }

  void _updatePassword(String id, Map<String, dynamic> data) {
    setState(() {
      final index = _allPasswords.indexWhere((p) => p.id == id);
      if (index != -1) {
        final password = _allPasswords[index];
        _allPasswords[index] = PasswordItem(
          id: password.id,
          title: data['title'] ?? password.title,
          username: data['username'] ?? password.username,
          password: data['password'] ?? password.password,
          url: data['url'] ?? password.url,
          category: data['category'] ?? password.category,
          notes: data['notes'] ?? password.notes,
          modified: 'Just now',
          modifiedBy: 'Current User',
          icon: password.icon,
          color: password.color,
          isFavorite: data['isFavorite'] ?? password.isFavorite,
          strength: _calculatePasswordStrength(data['password'] ?? password.password),
          lastUsed: password.lastUsed,
          expiryDays: data['expiryDays'] ?? password.expiryDays,
        );
        _filterPasswords();
      }
    });
    _showSnackBar('Password updated successfully', isError: false);
  }

  void _showSharePasswordDialog(PasswordItem password) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1E33),
              Color(0xFF061016),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Share "${password.title}"',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose what to share',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Share options
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildShareOptionTile(
                            icon: Icons.person,
                            title: 'Username only',
                            subtitle: 'Share just the username',
                            onTap: () {
                              Navigator.pop(context);
                              _copyToClipboard(password.username, 'Username');
                            },
                          ),
                          _buildShareOptionTile(
                            icon: Icons.lock,
                            title: 'Password only',
                            subtitle: 'Share just the password',
                            onTap: () {
                              Navigator.pop(context);
                              _copyToClipboard(password.password, 'Password');
                            },
                          ),
                          _buildShareOptionTile(
                            icon: Icons.link,
                            title: 'URL only',
                            subtitle: 'Share the website URL',
                            onTap: () {
                              if (password.url != null) {
                                Navigator.pop(context);
                                _copyToClipboard(password.url!, 'URL');
                              }
                            },
                          ),
                          _buildShareOptionTile(
                            icon: Icons.all_inbox,
                            title: 'All details',
                            subtitle: 'Share complete login info',
                            onTap: () {
                              Navigator.pop(context);
                              final allDetails = '''
Title: ${password.title}
Username: ${password.username}
Password: ${password.password}
URL: ${password.url ?? 'N/A'}
Notes: ${password.notes ?? 'N/A'}
''';
                              _copyToClipboard(allDetails, 'All details');
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Warning
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            size: 20,
                            color: Colors.orange.shade300,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Be careful when sharing passwords. Only share with trusted family members.',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.orange.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade300, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.montserrat(
          fontSize: 11,
          color: Colors.white60,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(PasswordItem password) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1E33),
        title: Text(
          'Delete Password',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${password.title}"? This action cannot be undone.',
          style: GoogleFonts.montserrat(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allPasswords.removeWhere((p) => p.id == password.id);
                _filterPasswords();
              });
              Navigator.pop(context);
              _showSnackBar('Password deleted', isError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _generatePassword() {
    const length = 12;
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0B1E33),
              const Color(0xFF061016),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passwords',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredPasswords.length} passwords • Family vault',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add password button
                    GestureDetector(
                      onTap: _showAddPasswordDialog,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4A90E2),
                              Color(0xFF67B26F),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search and filters
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search passwords...',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.white38,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: isSelected,
                              label: Text(filter),
                              labelStyle: GoogleFonts.montserrat(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 12,
                              ),
                              backgroundColor: Colors.white.withOpacity(0.05),
                              selectedColor: isSelected
                                  ? const Color(0xFF4A90E2)
                                  : null,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.white.withOpacity(0.1),
                                ),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                  _filterPasswords();
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Passwords list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredPasswords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.password,
                                  size: 80,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No passwords found',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add your first password to get started',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _showAddPasswordDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Password'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredPasswords.length,
                            itemBuilder: (context, index) {
                              final password = _filteredPasswords[index];
                              return FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildPasswordTile(password),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTile(PasswordItem password) {
    final isVisible = _visiblePasswords.contains(password.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () => _showPasswordOptions(password),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: password.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  password.icon,
                  color: password.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Password details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            password.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (password.isFavorite)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red.shade300,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      password.username,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStrengthColor(password.strength).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getStrengthColor(password.strength),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getStrengthText(password.strength),
                                style: GoogleFonts.montserrat(
                                  fontSize: 9,
                                  color: _getStrengthColor(password.strength),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            password.category,
                            style: GoogleFonts.montserrat(
                              fontSize: 9,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 10,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Modified ${password.modified}',
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  IconButton(
                    onPressed: () => _togglePasswordVisibility(password.id),
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: Colors.white60,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isVisible ? password.password : '••••••••',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.white60,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Password Dialog
class AddPasswordDialog extends StatefulWidget {
  const AddPasswordDialog({super.key});

  @override
  State<AddPasswordDialog> createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends State<AddPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCategory = 'Social';
  bool _isFavorite = false;
  int _expiryDays = 90;
  bool _showPassword = false;

  final List<String> _categories = [
    'Social', 'Finance', 'Work', 'Shopping', 'Entertainment', 'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _generateStrongPassword() {
    const length = 14;
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Add New Password',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., Gmail, Facebook',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.label, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username/Email *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Enter username or email',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.person, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password with generate button
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          style: GoogleFonts.montserrat(color: Colors.white),
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                            hintText: 'Enter password',
                            hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                            prefixIcon: Icon(Icons.lock, color: Colors.blue.shade300),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(
                                _showPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue.shade300),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _passwordController.text = _generateStrongPassword();
                          },
                          icon: const Icon(
                            Icons.autorenew,
                            color: Colors.green,
                          ),
                          tooltip: 'Generate strong password',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // URL
                  TextFormField(
                    controller: _urlController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Website URL',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., https://example.com',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.link, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    dropdownColor: const Color(0xFF0B1E33),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.category, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Expiry days
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: '90',
                          style: GoogleFonts.montserrat(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Expiry days',
                            labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                            hintText: '90',
                            hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                            prefixIcon: Icon(Icons.timer, color: Colors.blue.shade300),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue.shade300),
                            ),
                          ),
                          onChanged: (value) {
                            _expiryDays = int.tryParse(value) ?? 90;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isFavorite,
                              onChanged: (value) {
                                setState(() {
                                  _isFavorite = value ?? false;
                                });
                              },
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.red;
                                }
                                return Colors.white24;
                              }),
                              checkColor: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Favorite',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Additional notes...',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.note, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, {
                          'title': _titleController.text,
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                          'url': _urlController.text,
                          'category': _selectedCategory,
                          'notes': _notesController.text,
                          'isFavorite': _isFavorite,
                          'expiryDays': _expiryDays,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Save Password'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Security note
            Row(
              children: [
                Icon(
                  Icons.security,
                  size: 12,
                  color: Colors.green.shade300,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Passwords are encrypted and only accessible to family members',
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      color: Colors.green.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Password Dialog
class EditPasswordDialog extends StatefulWidget {
  final PasswordItem password;

  const EditPasswordDialog({super.key, required this.password});

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;
  
  late String _selectedCategory;
  late bool _isFavorite;
  late int _expiryDays;
  bool _showPassword = false;

  final List<String> _categories = [
    'Social', 'Finance', 'Work', 'Shopping', 'Entertainment', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.password.title);
    _usernameController = TextEditingController(text: widget.password.username);
    _passwordController = TextEditingController(text: widget.password.password);
    _urlController = TextEditingController(text: widget.password.url);
    _notesController = TextEditingController(text: widget.password.notes);
    _selectedCategory = widget.password.category;
    _isFavorite = widget.password.isFavorite;
    _expiryDays = widget.password.expiryDays;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Edit Password',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Form (similar to add dialog)
            Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.label, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _usernameController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username/Email *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.person, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        style: GoogleFonts.montserrat(color: Colors.white),
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                          prefixIcon: Icon(Icons.lock, color: Colors.blue.shade300),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _urlController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Website URL',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.link, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color(0xFF0B1E33),
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.category, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _expiryDays.toString(),
                        style: GoogleFonts.montserrat(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expiry days',
                          labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                          prefixIcon: Icon(Icons.timer, color: Colors.blue.shade300),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                        ),
                        onChanged: (value) {
                          _expiryDays = int.tryParse(value) ?? 90;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isFavorite,
                            onChanged: (value) {
                              setState(() {
                                _isFavorite = value ?? false;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.red;
                              }
                              return Colors.white24;
                            }),
                            checkColor: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Favorite',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.note, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'title': _titleController.text,
                        'username': _usernameController.text,
                        'password': _passwordController.text,
                        'url': _urlController.text,
                        'category': _selectedCategory,
                        'notes': _notesController.text,
                        'isFavorite': _isFavorite,
                        'expiryDays': _expiryDays,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Update Password'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong
}

class PasswordItem {
  final String id;
  final String title;
  final String username;
  final String password;
  final String? url;
  final String category;
  final String? notes;
  final String modified;
  final String modifiedBy;
  final IconData icon;
  final Color color;
  bool isFavorite;
  final PasswordStrength strength;
  final String lastUsed;
  final int expiryDays;

  PasswordItem({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    required this.category,
    this.notes,
    required this.modified,
    required this.modifiedBy,
    required this.icon,
    required this.color,
    required this.isFavorite,
    required this.strength,
    required this.lastUsed,
    required this.expiryDays,
  });
}