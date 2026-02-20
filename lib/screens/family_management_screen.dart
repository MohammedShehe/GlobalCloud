import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  List<FamilyMember> _familyMembers = [];
  List<FamilyMember> _filteredMembers = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Adults', 'Children', 'Admins', 'Active', 'Inactive'];
  
  // Family settings
  String _familyName = "4 Brothers";
  String _familyEmail = "family@4brothers.com";
  String _familyPhone = "+1 (555) 123-4567";
  String _familyAddress = "123 Main Street, Springfield, USA";
  DateTime _familyCreated = DateTime.now().subtract(const Duration(days: 365));
  int _storageUsed = 42; // GB
  int _storageTotal = 100; // GB
  int _totalDocuments = 156;
  int _totalPhotos = 324;
  int _totalVideos = 45;
  
  // Activity log
  List<ActivityItem> _recentActivities = [];

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
    
    // Load mock family data
    _loadFamilyData();
    
    _searchController.addListener(_filterMembers);
  }

  void _loadFamilyData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _familyMembers = [
          FamilyMember(
            id: '1',
            firstName: 'John',
            secondName: 'Michael',
            thirdName: 'Doe',
            email: 'john.doe@email.com',
            phone: '+1 (555) 111-1111',
            role: FamilyRole.admin,
            status: MemberStatus.active,
            dateJoined: DateTime.now().subtract(const Duration(days: 365)),
            lastActive: DateTime.now().subtract(const Duration(hours: 2)),
            avatarColor: Colors.blue,
            storageUsed: 15.5,
            documentsCount: 45,
            photosCount: 120,
            videosCount: 18,
            isOnline: true,
            birthday: DateTime(1985, 5, 15),
            relationship: 'Father',
          ),
          FamilyMember(
            id: '2',
            firstName: 'Sarah',
            secondName: 'Elizabeth',
            thirdName: 'Smith',
            email: 'sarah.smith@email.com',
            phone: '+1 (555) 222-2222',
            role: FamilyRole.admin,
            status: MemberStatus.active,
            dateJoined: DateTime.now().subtract(const Duration(days: 365)),
            lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
            avatarColor: Colors.pink,
            storageUsed: 12.8,
            documentsCount: 38,
            photosCount: 95,
            videosCount: 12,
            isOnline: true,
            birthday: DateTime(1987, 8, 22),
            relationship: 'Mother',
          ),
          FamilyMember(
            id: '3',
            firstName: 'Emma',
            secondName: 'Rose',
            thirdName: 'Doe',
            email: 'emma.doe@email.com',
            phone: '+1 (555) 333-3333',
            role: FamilyRole.member,
            status: MemberStatus.active,
            dateJoined: DateTime.now().subtract(const Duration(days: 365)),
            lastActive: DateTime.now().subtract(const Duration(hours: 5)),
            avatarColor: Colors.purple,
            storageUsed: 8.2,
            documentsCount: 28,
            photosCount: 65,
            videosCount: 8,
            isOnline: false,
            birthday: DateTime(2012, 3, 10),
            relationship: 'Daughter',
          ),
          FamilyMember(
            id: '4',
            firstName: 'Michael',
            secondName: 'James',
            thirdName: 'Doe',
            email: 'michael.doe@email.com',
            phone: '+1 (555) 444-4444',
            role: FamilyRole.member,
            status: MemberStatus.active,
            dateJoined: DateTime.now().subtract(const Duration(days: 365)),
            lastActive: DateTime.now().subtract(const Duration(days: 1)),
            avatarColor: Colors.green,
            storageUsed: 5.5,
            documentsCount: 15,
            photosCount: 44,
            videosCount: 7,
            isOnline: false,
            birthday: DateTime(2015, 11, 28),
            relationship: 'Son',
          ),
          FamilyMember(
            id: '5',
            firstName: 'Robert',
            secondName: 'William',
            thirdName: 'Johnson',
            email: 'robert.j@email.com',
            phone: '+1 (555) 555-5555',
            role: FamilyRole.guest,
            status: MemberStatus.active,
            dateJoined: DateTime.now().subtract(const Duration(days: 60)),
            lastActive: DateTime.now().subtract(const Duration(days: 3)),
            avatarColor: Colors.orange,
            storageUsed: 0.5,
            documentsCount: 2,
            photosCount: 8,
            videosCount: 0,
            isOnline: false,
            birthday: DateTime(1950, 7, 3),
            relationship: 'Grandfather',
          ),
          FamilyMember(
            id: '6',
            firstName: 'Elizabeth',
            secondName: 'Marie',
            thirdName: 'Johnson',
            email: 'elizabeth.j@email.com',
            phone: '+1 (555) 666-6666',
            role: FamilyRole.guest,
            status: MemberStatus.inactive,
            dateJoined: DateTime.now().subtract(const Duration(days: 60)),
            lastActive: DateTime.now().subtract(const Duration(days: 30)),
            avatarColor: Colors.teal,
            storageUsed: 0.3,
            documentsCount: 1,
            photosCount: 5,
            videosCount: 0,
            isOnline: false,
            birthday: DateTime(1952, 9, 18),
            relationship: 'Grandmother',
          ),
          FamilyMember(
            id: '7',
            firstName: 'David',
            secondName: 'Thomas',
            thirdName: 'Brown',
            email: 'david.b@email.com',
            phone: '+1 (555) 777-7777',
            role: FamilyRole.member,
            status: MemberStatus.pending,
            dateJoined: DateTime.now().subtract(const Duration(days: 2)),
            lastActive: null,
            avatarColor: Colors.cyan,
            storageUsed: 0,
            documentsCount: 0,
            photosCount: 0,
            videosCount: 0,
            isOnline: false,
            birthday: DateTime(1990, 12, 5),
            relationship: 'Cousin',
          ),
        ];

        _recentActivities = [
          ActivityItem(
            id: 'a1',
            type: ActivityType.member_added,
            description: 'New member David Brown joined the family',
            performedBy: 'John Doe',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            icon: Icons.person_add,
            color: Colors.green,
          ),
          ActivityItem(
            id: 'a2',
            type: ActivityType.password_changed,
            description: 'Family password was changed',
            performedBy: 'Sarah Smith',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            icon: Icons.lock,
            color: Colors.orange,
          ),
          ActivityItem(
            id: 'a3',
            type: ActivityType.settings_updated,
            description: 'Family name updated to "4 Brothers"',
            performedBy: 'John Doe',
            timestamp: DateTime.now().subtract(const Duration(days: 7)),
            icon: Icons.settings,
            color: Colors.blue,
          ),
          ActivityItem(
            id: 'a4',
            type: ActivityType.member_removed,
            description: 'Member "Jane Smith" was removed',
            performedBy: 'Admin',
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            icon: Icons.person_remove,
            color: Colors.red,
          ),
          ActivityItem(
            id: 'a5',
            type: ActivityType.role_changed,
            description: 'Emma Doe role changed to Member',
            performedBy: 'John Doe',
            timestamp: DateTime.now().subtract(const Duration(days: 12)),
            icon: Icons.admin_panel_settings,
            color: Colors.purple,
          ),
        ];

        _filteredMembers = _familyMembers;
        _isLoading = false;
      });
    });
  }

  void _filterMembers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _familyMembers.where((member) {
        final fullName = '${member.firstName} ${member.secondName} ${member.thirdName}'.toLowerCase();
        final email = member.email.toLowerCase();
        final phone = member.phone.toLowerCase();
        final relationship = member.relationship.toLowerCase();

        final matchesSearch = query.isEmpty ||
            fullName.contains(query) ||
            email.contains(query) ||
            phone.contains(query) ||
            relationship.contains(query);

        if (!matchesSearch) return false;

        // Apply filters
        switch (_selectedFilter) {
          case 'Adults':
            return _getAge(member.birthday) >= 18;
          case 'Children':
            return _getAge(member.birthday) < 18;
          case 'Admins':
            return member.role == FamilyRole.admin;
          case 'Active':
            return member.status == MemberStatus.active;
          case 'Inactive':
            return member.status != MemberStatus.active;
          default:
            return true;
        }
      }).toList();
    });
  }

  int _getAge(DateTime birthday) {
    final today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month || 
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: const AddMemberDialog(),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _addNewMember(value);
      }
    });
  }

  void _addNewMember(Map<String, dynamic> data) {
    setState(() {
      final newMember = FamilyMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: data['firstName'],
        secondName: data['secondName'],
        thirdName: data['thirdName'],
        email: data['email'],
        phone: data['phone'],
        role: data['role'],
        status: MemberStatus.pending,
        dateJoined: DateTime.now(),
        lastActive: null,
        avatarColor: _getRandomColor(),
        storageUsed: 0,
        documentsCount: 0,
        photosCount: 0,
        videosCount: 0,
        isOnline: false,
        birthday: data['birthday'],
        relationship: data['relationship'],
      );
      
      _familyMembers.add(newMember);
      _filterMembers();
      
      // Add to activity log
      _recentActivities.insert(0, ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.member_added,
        description: 'New member ${newMember.firstName} ${newMember.secondName} joined the family',
        performedBy: 'Current User',
        timestamp: DateTime.now(),
        icon: Icons.person_add,
        color: Colors.green,
      ));
    });

    _showSnackBar('Member added successfully', isError: false);
  }

  Color _getRandomColor() {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.pink, Colors.teal, Colors.cyan];
    return colors[Random().nextInt(colors.length)];
  }

  void _showEditMemberDialog(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: EditMemberDialog(member: member),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _updateMember(member.id, value);
      }
    });
  }

  void _updateMember(String id, Map<String, dynamic> data) {
    setState(() {
      final index = _familyMembers.indexWhere((m) => m.id == id);
      if (index != -1) {
        final oldMember = _familyMembers[index];
        _familyMembers[index] = FamilyMember(
          id: oldMember.id,
          firstName: data['firstName'] ?? oldMember.firstName,
          secondName: data['secondName'] ?? oldMember.secondName,
          thirdName: data['thirdName'] ?? oldMember.thirdName,
          email: data['email'] ?? oldMember.email,
          phone: data['phone'] ?? oldMember.phone,
          role: data['role'] ?? oldMember.role,
          status: data['status'] ?? oldMember.status,
          dateJoined: oldMember.dateJoined,
          lastActive: oldMember.lastActive,
          avatarColor: oldMember.avatarColor,
          storageUsed: oldMember.storageUsed,
          documentsCount: oldMember.documentsCount,
          photosCount: oldMember.photosCount,
          videosCount: oldMember.videosCount,
          isOnline: oldMember.isOnline,
          birthday: data['birthday'] ?? oldMember.birthday,
          relationship: data['relationship'] ?? oldMember.relationship,
        );
        _filterMembers();
      }
    });
    _showSnackBar('Member updated successfully', isError: false);
  }

  void _showRemoveMemberConfirmation(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1E33),
        title: Text(
          'Remove Member',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to remove ${member.firstName} ${member.secondName} from the family?',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade300, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This will revoke all access and delete all data associated with this member.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                _familyMembers.removeWhere((m) => m.id == member.id);
                _filterMembers();
                
                // Add to activity log
                _recentActivities.insert(0, ActivityItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: ActivityType.member_removed,
                  description: '${member.firstName} ${member.secondName} was removed from the family',
                  performedBy: 'Current User',
                  timestamp: DateTime.now(),
                  icon: Icons.person_remove,
                  color: Colors.red,
                ));
              });
              Navigator.pop(context);
              _showSnackBar('Member removed', isError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: const ChangePasswordDialog(),
      ),
    ).then((value) {
      if (value != null && value == true) {
        _showSnackBar('Password changed successfully', isError: false);
        
        // Add to activity log
        setState(() {
          _recentActivities.insert(0, ActivityItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: ActivityType.password_changed,
            description: 'Family password was changed',
            performedBy: 'Current User',
            timestamp: DateTime.now(),
            icon: Icons.lock,
            color: Colors.orange,
          ));
        });
      }
    });
  }

  void _showEditFamilyInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: EditFamilyInfoDialog(
          familyName: _familyName,
          familyEmail: _familyEmail,
          familyPhone: _familyPhone,
          familyAddress: _familyAddress,
        ),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        setState(() {
          _familyName = value['familyName'] ?? _familyName;
          _familyEmail = value['familyEmail'] ?? _familyEmail;
          _familyPhone = value['familyPhone'] ?? _familyPhone;
          _familyAddress = value['familyAddress'] ?? _familyAddress;
          
          // Add to activity log
          _recentActivities.insert(0, ActivityItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: ActivityType.settings_updated,
            description: 'Family information was updated',
            performedBy: 'Current User',
            timestamp: DateTime.now(),
            icon: Icons.settings,
            color: Colors.blue,
          ));
        });
        _showSnackBar('Family information updated', isError: false);
      }
    });
  }

  void _showMemberDetails(FamilyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with avatar
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  member.avatarColor.withOpacity(0.7),
                                  member.avatarColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                member.firstName[0] + (member.secondName.isNotEmpty ? member.secondName[0] : ''),
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${member.firstName} ${member.secondName} ${member.thirdName}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRoleColor(member.role).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        member.role.toString().split('.').last,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: _getRoleColor(member.role),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: member.status == MemberStatus.active
                                            ? Colors.green.withOpacity(0.2)
                                            : member.status == MemberStatus.pending
                                                ? Colors.orange.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        member.status.toString().split('.').last,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: member.status == MemberStatus.active
                                              ? Colors.green
                                              : member.status == MemberStatus.pending
                                                  ? Colors.orange
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Online status
                      if (member.isOnline)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Online Now',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (member.lastActive != null)
                        Text(
                          'Last active: ${_formatRelativeTime(member.lastActive!)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Contact Information
                      _buildInfoSection(
                        'Contact Information',
                        Icons.contact_mail,
                        [
                          _buildInfoRow(Icons.email, 'Email', member.email, canCopy: true),
                          _buildInfoRow(Icons.phone, 'Phone', member.phone, canCopy: true),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Personal Information
                      _buildInfoSection(
                        'Personal Information',
                        Icons.person,
                        [
                          _buildInfoRow(Icons.cake, 'Birthday', _formatDate(member.birthday)),
                          _buildInfoRow(Icons.family_restroom, 'Relationship', member.relationship),
                          _buildInfoRow(Icons.calendar_today, 'Joined', _formatDate(member.dateJoined)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Storage Usage
                      _buildInfoSection(
                        'Storage Usage',
                        Icons.cloud,
                        [
                          _buildStorageRow('Documents', member.documentsCount, member.storageUsed * 0.4),
                          _buildStorageRow('Photos', member.photosCount, member.storageUsed * 0.4),
                          _buildStorageRow('Videos', member.videosCount, member.storageUsed * 0.2),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: member.storageUsed / 20, // Assuming 20GB limit per user
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${member.storageUsed.toStringAsFixed(1)} GB of 20 GB used',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.pop(context);
                                _showEditMemberDialog(member);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.admin_panel_settings,
                              label: 'Change Role',
                              color: Colors.purple,
                              onTap: () {
                                Navigator.pop(context);
                                _showChangeRoleDialog(member);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.block,
                              label: member.status == MemberStatus.active ? 'Suspend' : 'Activate',
                              color: member.status == MemberStatus.active ? Colors.orange : Colors.green,
                              onTap: () {
                                Navigator.pop(context);
                                _toggleMemberStatus(member);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.delete_outline,
                              label: 'Remove',
                              color: Colors.red,
                              onTap: () {
                                Navigator.pop(context);
                                _showRemoveMemberConfirmation(member);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade300, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              onPressed: () => _copyToClipboard(value, label),
              icon: Icon(Icons.copy, size: 16, color: Colors.white60),
            ),
        ],
      ),
    );
  }

  Widget _buildStorageRow(String label, int count, double storage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$count files',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ),
          Text(
            '${storage.toStringAsFixed(1)} GB',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeRoleDialog(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1E33),
        title: Text(
          'Change Role',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: FamilyRole.values.map((role) {
            return RadioListTile<FamilyRole>(
              title: Text(
                role.toString().split('.').last,
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              value: role,
              groupValue: member.role,
              onChanged: (value) {
                Navigator.pop(context);
                setState(() {
                  member.role = value!;
                });
                _showSnackBar('Role updated to ${value.toString().split('.').last}', isError: false);
              },
              activeColor: _getRoleColor(role),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMemberStatus(FamilyMember member) {
    setState(() {
      member.status = member.status == MemberStatus.active 
          ? MemberStatus.inactive 
          : MemberStatus.active;
    });
    _showSnackBar(
      member.status == MemberStatus.active 
          ? 'Member activated' 
          : 'Member suspended',
      isError: false,
    );
  }

  void _copyToClipboard(String text, String label) {
    // In real app: Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('$label copied to clipboard', isError: false);
  }

  Color _getRoleColor(FamilyRole role) {
    switch (role) {
      case FamilyRole.admin:
        return Colors.red;
      case FamilyRole.member:
        return Colors.blue;
      case FamilyRole.guest:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatRelativeTime(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
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
                            'Family Management',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Admin controls & settings',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Family Info Card
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.2),
                      Colors.purple.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.family_restroom,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _familyName,
                                style: GoogleFonts.montserrat(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Family since ${DateFormat('yyyy').format(_familyCreated)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Quick access password change icon
                        IconButton(
                          onPressed: _showChangePasswordDialog,
                          icon: Icon(Icons.lock, color: Colors.orange.shade300),
                          tooltip: 'Change Password',
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _showEditFamilyInfoDialog,
                          icon: Icon(Icons.edit, color: Colors.blue.shade300),
                          tooltip: 'Edit Family Info',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(Icons.people, '${_familyMembers.length}', 'Members'),
                        _buildStatColumn(Icons.cloud, '${_storageUsed}GB', 'Used'),
                        _buildStatColumn(Icons.description, '$_totalDocuments', 'Docs'),
                        _buildStatColumn(Icons.photo_library, '$_totalPhotos', 'Photos'),
                      ],
                    ),

                    // Prominent password change button
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showChangePasswordDialog,
                        icon: const Icon(Icons.lock, color: Colors.white),
                        label: Text(
                          'Change Family Password',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Storage bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Storage',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              '$_storageUsed GB / $_storageTotal GB',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _storageUsed / _storageTotal,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Management Tabs - FIXED OVERFLOW ISSUE
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF67B26F),
                              ],
                            ),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white60,
                          tabs: const [
                            Tab(text: 'Members'),
                            Tab(text: 'Activity'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // TabBarView takes remaining space
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Members Tab
                            _buildMembersTab(),
                            // Activity Tab
                            _buildActivityTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade300, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    return Column(
      children: [
        // Search and filters - fixed height section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.montserrat(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search members...',
                          hintStyle: GoogleFonts.montserrat(color: Colors.white38),
                          prefixIcon: const Icon(Icons.search, color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: _showAddMemberDialog,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF67B26F),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

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
                            _filterMembers();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // Members list - Expanded to take remaining space
        Expanded(
          child: _isLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: Colors.blue.shade300,
                    size: 30,
                  ),
                )
              : _filteredMembers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 60,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No members found',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = _filteredMembers[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildMemberTile(member),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildActivityTab() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // Activity list - Expanded to take remaining space
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _recentActivities.length,
            itemBuilder: (context, index) {
              final activity = _recentActivities[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activity.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activity.icon,
                        color: activity.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.description,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'by ${activity.performedBy}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: Colors.white38,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatRelativeTime(activity.timestamp),
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemberTile(FamilyMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: member.isOnline
              ? Colors.green.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: member.isOnline ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showMemberDetails(member),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      member.avatarColor.withOpacity(0.7),
                      member.avatarColor,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member.firstName[0] + (member.secondName.isNotEmpty ? member.secondName[0] : ''),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Member details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${member.firstName} ${member.secondName}',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: member.isOnline
                                ? Colors.green
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.relationship,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
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
                            color: _getRoleColor(member.role).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            member.role.toString().split('.').last,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: _getRoleColor(member.role),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (member.status != MemberStatus.active)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: member.status == MemberStatus.pending
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              member.status.toString().split('.').last,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: member.status == MemberStatus.pending
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showEditMemberDialog(member),
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.blue.shade300,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showRemoveMemberConfirmation(member),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade300,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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

// Add Member Dialog
class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _thirdNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();
  
  DateTime _selectedBirthday = DateTime.now().subtract(const Duration(days: 365 * 10));
  FamilyRole _selectedRole = FamilyRole.member;

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              surface: Color(0xFF0B1E33),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
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
                    color: Colors.green.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Add Family Member',
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
                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'First Name *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
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
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Second Name
                  TextFormField(
                    controller: _secondNameController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Second Name *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
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
                        return 'Please enter second name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Third Name
                  TextFormField(
                    controller: _thirdNameController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Third Name *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
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
                        return 'Please enter third name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.email, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.phone, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birthday
                  InkWell(
                    onTap: _selectBirthday,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cake, color: Colors.blue.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birthday *',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(_selectedBirthday),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.white60),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Relationship
                  TextFormField(
                    controller: _relationshipController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Relationship *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., Father, Mother, Son, Daughter',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.family_restroom, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter relationship';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Role
                  DropdownButtonFormField<FamilyRole>(
                    value: _selectedRole,
                    dropdownColor: const Color(0xFF0B1E33),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Role *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.admin_panel_settings, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    items: FamilyRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
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
                          'firstName': _firstNameController.text,
                          'secondName': _secondNameController.text,
                          'thirdName': _thirdNameController.text,
                          'email': _emailController.text,
                          'phone': _phoneController.text,
                          'birthday': _selectedBirthday,
                          'relationship': _relationshipController.text,
                          'role': _selectedRole,
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
                    child: const Text('Add Member'),
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

// Edit Member Dialog
class EditMemberDialog extends StatefulWidget {
  final FamilyMember member;

  const EditMemberDialog({super.key, required this.member});

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _secondNameController;
  late final TextEditingController _thirdNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;
  
  late DateTime _selectedBirthday;
  late FamilyRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.member.firstName);
    _secondNameController = TextEditingController(text: widget.member.secondName);
    _thirdNameController = TextEditingController(text: widget.member.thirdName);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneController = TextEditingController(text: widget.member.phone);
    _relationshipController = TextEditingController(text: widget.member.relationship);
    _selectedBirthday = widget.member.birthday;
    _selectedRole = widget.member.role;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
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
                    'Edit Member',
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
                  controller: _firstNameController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'First Name *',
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

                TextFormField(
                  controller: _secondNameController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Second Name *',
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

                TextFormField(
                  controller: _thirdNameController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Third Name *',
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

                TextFormField(
                  controller: _emailController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.email, color: Colors.blue.shade300),
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
                  controller: _phoneController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.phone, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake, color: Colors.blue.shade300),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Birthday',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(_selectedBirthday),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _relationshipController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Relationship *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.family_restroom, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<FamilyRole>(
                  value: _selectedRole,
                  dropdownColor: const Color(0xFF0B1E33),
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Role *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.admin_panel_settings, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  items: FamilyRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
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
                        'firstName': _firstNameController.text,
                        'secondName': _secondNameController.text,
                        'thirdName': _thirdNameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'birthday': _selectedBirthday,
                        'relationship': _relationshipController.text,
                        'role': _selectedRole,
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
                    child: const Text('Update Member'),
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

// Change Password Dialog
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Change Family Password',
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
                // Current Password
                TextFormField(
                  controller: _currentPasswordController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  obscureText: !_showCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Current Password *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade300),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showCurrentPassword = !_showCurrentPassword;
                        });
                      },
                      icon: Icon(
                        _showCurrentPassword ? Icons.visibility_off : Icons.visibility,
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
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // New Password
                TextFormField(
                  controller: _newPasswordController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  obscureText: !_showNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue.shade300),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                      icon: Icon(
                        _showNewPassword ? Icons.visibility_off : Icons.visibility,
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
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  obscureText: !_showConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue.shade300),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
                      return 'Please confirm new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password requirements
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildRequirement('At least 6 characters long'),
                      _buildRequirement('Contains uppercase and lowercase letters'),
                      _buildRequirement('Contains at least one number'),
                      _buildRequirement('Contains at least one special character'),
                    ],
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
                      // In real app, verify current password and update
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 14,
            color: Colors.green.shade300,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// Edit Family Info Dialog
class EditFamilyInfoDialog extends StatefulWidget {
  final String familyName;
  final String familyEmail;
  final String familyPhone;
  final String familyAddress;

  const EditFamilyInfoDialog({
    super.key,
    required this.familyName,
    required this.familyEmail,
    required this.familyPhone,
    required this.familyAddress,
  });

  @override
  State<EditFamilyInfoDialog> createState() => _EditFamilyInfoDialogState();
}

class _EditFamilyInfoDialogState extends State<EditFamilyInfoDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.familyName);
    _emailController = TextEditingController(text: widget.familyEmail);
    _phoneController = TextEditingController(text: widget.familyPhone);
    _addressController = TextEditingController(text: widget.familyAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
                  Icons.family_restroom,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Edit Family Information',
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
          Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Family Name',
                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                  prefixIcon: Icon(Icons.family_restroom, color: Colors.blue.shade300),
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
                controller: _emailController,
                style: GoogleFonts.montserrat(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Family Email',
                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade300),
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
                controller: _phoneController,
                style: GoogleFonts.montserrat(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Family Phone',
                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                  prefixIcon: Icon(Icons.phone, color: Colors.blue.shade300),
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
                controller: _addressController,
                style: GoogleFonts.montserrat(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Family Address',
                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                  prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade300),
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
                      'familyName': _nameController.text,
                      'familyEmail': _emailController.text,
                      'familyPhone': _phoneController.text,
                      'familyAddress': _addressController.text,
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
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Models
enum FamilyRole {
  admin,
  member,
  guest
}

enum MemberStatus {
  active,
  pending,
  inactive
}

enum ActivityType {
  member_added,
  member_removed,
  password_changed,
  settings_updated,
  role_changed
}

class FamilyMember {
  final String id;
  String firstName;
  String secondName;
  String thirdName;
  String email;
  String phone;
  FamilyRole role;
  MemberStatus status;
  final DateTime dateJoined;
  DateTime? lastActive;
  final Color avatarColor;
  final double storageUsed;
  final int documentsCount;
  final int photosCount;
  final int videosCount;
  bool isOnline;
  final DateTime birthday;
  final String relationship;

  FamilyMember({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.dateJoined,
    this.lastActive,
    required this.avatarColor,
    required this.storageUsed,
    required this.documentsCount,
    required this.photosCount,
    required this.videosCount,
    required this.isOnline,
    required this.birthday,
    required this.relationship,
  });
}

class ActivityItem {
  final String id;
  final ActivityType type;
  final String description;
  final String performedBy;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.id,
    required this.type,
    required this.description,
    required this.performedBy,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}