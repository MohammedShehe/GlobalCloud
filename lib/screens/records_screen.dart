import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<RecordItem> _allRecords = [];
  List<RecordItem> _filteredRecords = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Financial', 'Legal', 'Medical', 'Property', 'Education', 'Other'];
  
  // Summary stats
  double _totalIncome = 0;
  double _totalExpenses = 0;
  int _pendingCount = 0;
  int _expiringCount = 0;

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
    
    // Load mock records
    _loadRecords();
    
    _searchController.addListener(_filterRecords);
  }

  void _loadRecords() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allRecords.addAll([
          // Financial Records
          RecordItem(
            id: '1',
            title: 'House Sold - 123 Main St',
            description: 'Sold family house, transferred ownership',
            recordType: RecordType.financial,
            category: 'Property Sale',
            amount: 450000.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 30)),
            dueDate: null,
            parties: ['John Doe', 'Jane Smith (Buyer)', 'Real Estate Agent'],
            location: 'City Hall',
            reference: 'DEED-2024-00123',
            tags: ['house', 'sale', 'important'],
            attachments: ['deed.pdf', 'contract.pdf', 'receipt.pdf'],
            notes: 'Sold to young family. All paperwork completed.',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 29)),
            color: Colors.green,
            icon: Icons.home,
            isFavorite: true,
          ),
          RecordItem(
            id: '2',
            title: 'Car Purchase - Toyota Camry 2024',
            description: 'Bought new family car',
            recordType: RecordType.financial,
            category: 'Vehicle',
            amount: 32000.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 15)),
            dueDate: null,
            parties: ['Toyota Dealership', 'John Doe'],
            location: 'City Toyota',
            reference: 'INV-2024-789',
            tags: ['car', 'purchase', 'vehicle'],
            attachments: ['invoice.pdf', 'warranty.pdf', 'registration.pdf'],
            notes: '5-year warranty included. First payment made.',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 14)),
            color: Colors.blue,
            icon: Icons.directions_car,
            isFavorite: false,
          ),
          RecordItem(
            id: '3',
            title: 'Monthly Rent Payment - December',
            description: 'Rent payment for family apartment',
            recordType: RecordType.financial,
            category: 'Rent',
            amount: 2500.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 5)),
            dueDate: DateTime.now().add(const Duration(days: 25)),
            parties: ['Landlord - Mr. Johnson'],
            location: 'Sunset Apartments',
            reference: 'RENT-2024-12',
            tags: ['rent', 'monthly', 'housing'],
            attachments: ['receipt.pdf'],
            notes: 'Paid via bank transfer',
            status: RecordStatus.completed,
            createdBy: 'Sarah Smith',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
            modifiedBy: 'Sarah Smith',
            modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
            color: Colors.purple,
            icon: Icons.apartment,
            isFavorite: false,
          ),
          
          // Legal Records
          RecordItem(
            id: '4',
            title: 'Last Will and Testament',
            description: 'Legal will document',
            recordType: RecordType.legal,
            category: 'Estate Planning',
            amount: null,
            currency: null,
            date: DateTime.now().subtract(const Duration(days: 180)),
            dueDate: null,
            parties: ['John Doe', 'Sarah Smith', 'Lawyer - Robert Brown'],
            location: 'Brown & Associates Law Firm',
            reference: 'WILL-2024-456',
            tags: ['will', 'estate', 'legal', 'important'],
            attachments: ['will_signed.pdf', 'witness_statement.pdf'],
            notes: 'Original at law firm, copy kept digitally',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 180)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 179)),
            color: Colors.red,
            icon: Icons.gavel,
            isFavorite: true,
          ),
          RecordItem(
            id: '5',
            title: 'Marriage Certificate',
            description: 'Official marriage certificate',
            recordType: RecordType.legal,
            category: 'Personal',
            amount: null,
            currency: null,
            date: DateTime.now().subtract(const Duration(days: 3650)),
            dueDate: null,
            parties: ['John Doe', 'Sarah Smith'],
            location: 'City Clerk Office',
            reference: 'MAR-2014-789',
            tags: ['marriage', 'personal', 'important'],
            attachments: ['certificate.pdf'],
            notes: 'Certified copy',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 3650)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 3640)),
            color: Colors.pink,
            icon: Icons.favorite,
            isFavorite: true,
          ),
          
          // Medical Records
          RecordItem(
            id: '6',
            title: 'Family Health Insurance',
            description: 'Annual family health insurance policy',
            recordType: RecordType.medical,
            category: 'Insurance',
            amount: 7200.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 45)),
            dueDate: DateTime.now().add(const Duration(days: 320)),
            parties: ['HealthPlus Insurance', 'All Family Members'],
            location: 'HealthPlus Office',
            reference: 'POL-2024-12345',
            tags: ['insurance', 'health', 'family'],
            attachments: ['policy.pdf', 'benefits.pdf', 'cards.pdf'],
            notes: 'Covers all family members. USD 500 deductible.',
            status: RecordStatus.active,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 45)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 44)),
            color: Colors.green,
            icon: Icons.health_and_safety,
            isFavorite: false,
          ),
          RecordItem(
            id: '7',
            title: 'Sarah\'s Vaccination Records',
            description: 'Complete vaccination history for Sarah',
            recordType: RecordType.medical,
            category: 'Immunization',
            amount: null,
            currency: null,
            date: DateTime.now().subtract(const Duration(days: 60)),
            dueDate: DateTime.now().add(const Duration(days: 120)),
            parties: ['Dr. Wilson', 'Sarah Smith'],
            location: 'Children\'s Medical Center',
            reference: 'VAC-2024-456',
            tags: ['vaccination', 'child', 'health'],
            attachments: ['vaccination_record.pdf', 'next_appointment.pdf'],
            notes: 'Next booster due in 4 months',
            status: RecordStatus.active,
            createdBy: 'Sarah Smith',
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            modifiedBy: 'Sarah Smith',
            modifiedAt: DateTime.now().subtract(const Duration(days: 59)),
            color: Colors.blue,
            icon: Icons.vaccines,
            isFavorite: true,
          ),
          
          // Property Records
          RecordItem(
            id: '8',
            title: 'House Insurance Policy',
            description: 'Homeowners insurance',
            recordType: RecordType.property,
            category: 'Insurance',
            amount: 1800.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 90)),
            dueDate: DateTime.now().add(const Duration(days: 275)),
            parties: ['SafeHome Insurance'],
            location: '123 Main St',
            reference: 'HOME-INS-2024',
            tags: ['house', 'insurance', 'property'],
            attachments: ['policy.pdf', 'coverage_details.pdf'],
            notes: 'Covers fire, theft, natural disasters',
            status: RecordStatus.active,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 89)),
            color: Colors.orange,
            icon: Icons.home_work,
            isFavorite: false,
          ),
          RecordItem(
            id: '9',
            title: 'Property Tax Payment',
            description: 'Annual property tax payment',
            recordType: RecordType.property,
            category: 'Taxes',
            amount: 5200.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 120)),
            dueDate: DateTime.now().add(const Duration(days: 245)),
            parties: ['County Tax Office'],
            location: '123 Main St',
            reference: 'TAX-2024-789',
            tags: ['taxes', 'property', 'annual'],
            attachments: ['tax_receipt.pdf'],
            notes: 'Paid in full for 2024',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 120)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 119)),
            color: Colors.red,
            icon: Icons.receipt,
            isFavorite: false,
          ),
          
          // Education Records
          RecordItem(
            id: '10',
            title: 'Sarah\'s School Tuition',
            description: 'Annual school fees for Sarah',
            recordType: RecordType.education,
            category: 'Tuition',
            amount: 15000.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 60)),
            dueDate: DateTime.now().add(const Duration(days: 305)),
            parties: ['Springfield Elementary School'],
            location: 'Springfield Elementary',
            reference: 'TUITION-2024-001',
            tags: ['school', 'education', 'tuition'],
            attachments: ['receipt.pdf', 'schedule.pdf'],
            notes: 'Includes lunch program and after-school care',
            status: RecordStatus.active,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 59)),
            color: Colors.teal,
            icon: Icons.school,
            isFavorite: true,
          ),
          RecordItem(
            id: '11',
            title: 'College Savings Plan',
            description: '529 plan contributions',
            recordType: RecordType.education,
            category: 'Savings',
            amount: 5000.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 30)),
            dueDate: null,
            parties: ['Education Trust', 'John Doe'],
            location: 'Online',
            reference: '529-2024-123',
            tags: ['college', 'savings', 'investment'],
            attachments: ['statement.pdf'],
            notes: 'Quarterly contribution',
            status: RecordStatus.active,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 29)),
            color: Colors.purple,
            icon: Icons.account_balance,
            isFavorite: false,
          ),
          
          // Payment Records
          RecordItem(
            id: '12',
            title: 'Credit Card Payment',
            description: 'Monthly credit card bill',
            recordType: RecordType.financial,
            category: 'Credit Card',
            amount: 3450.75,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 10)),
            dueDate: DateTime.now().add(const Duration(days: 15)),
            parties: ['Chase Bank'],
            location: 'Online',
            reference: 'CC-2024-12-01',
            tags: ['credit', 'payment', 'monthly'],
            attachments: ['statement.pdf'],
            notes: 'Paid in full',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 10)),
            color: Colors.indigo,
            icon: Icons.credit_card,
            isFavorite: false,
          ),
          RecordItem(
            id: '13',
            title: 'Mortgage Payment - December',
            description: 'Monthly mortgage payment',
            recordType: RecordType.financial,
            category: 'Mortgage',
            amount: 2100.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 7)),
            dueDate: DateTime.now().add(const Duration(days: 23)),
            parties: ['Wells Fargo Bank'],
            location: '123 Main St',
            reference: 'MORT-2024-12',
            tags: ['mortgage', 'house', 'payment'],
            attachments: ['payment_confirmation.pdf'],
            notes: 'Auto-payment setup',
            status: RecordStatus.completed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
            color: Colors.brown,
            icon: Icons.account_balance,
            isFavorite: false,
          ),
          
          // Other Records
          RecordItem(
            id: '14',
            title: 'Car Insurance Policy',
            description: 'Annual car insurance for both family cars',
            recordType: RecordType.financial,
            category: 'Insurance',
            amount: 2400.00,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 120)),
            dueDate: DateTime.now().add(const Duration(days: 245)),
            parties: ['Geico Insurance'],
            location: 'Online',
            reference: 'AUTO-INS-2024',
            tags: ['car', 'insurance', 'vehicles'],
            attachments: ['policy.pdf', 'cards.pdf'],
            notes: 'Covers both Toyota Camry and Honda CR-V',
            status: RecordStatus.active,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 120)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 119)),
            color: Colors.cyan,
            icon: Icons.time_to_leave,
            isFavorite: false,
          ),
          RecordItem(
            id: '15',
            title: 'Utility Bills - December',
            description: 'Monthly utilities: electricity, water, gas',
            recordType: RecordType.financial,
            category: 'Utilities',
            amount: 450.25,
            currency: 'USD',
            date: DateTime.now().subtract(const Duration(days: 3)),
            dueDate: DateTime.now().add(const Duration(days: 12)),
            parties: ['City Utilities', 'Gas Company'],
            location: '123 Main St',
            reference: 'UTIL-2024-12',
            tags: ['utilities', 'bills', 'monthly'],
            attachments: ['electric.pdf', 'water.pdf', 'gas.pdf'],
            notes: 'All paid online',
            status: RecordStatus.completed,
            createdBy: 'Sarah Smith',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            modifiedBy: 'Sarah Smith',
            modifiedAt: DateTime.now().subtract(const Duration(days: 3)),
            color: Colors.amber,
            icon: Icons.electrical_services,
            isFavorite: false,
          ),
        ]);
        
        _calculateStats();
        _filterRecords();
        _isLoading = false;
      });
    });
  }

  void _calculateStats() {
    _totalIncome = 0;
    _totalExpenses = 0;
    _pendingCount = 0;
    _expiringCount = 0;
    
    for (var record in _allRecords) {
      if (record.amount != null) {
        if (record.category.contains('Sale') || record.category.contains('Income')) {
          _totalIncome += record.amount!;
        } else {
          _totalExpenses += record.amount!;
        }
      }
      
      if (record.status == RecordStatus.pending) {
        _pendingCount++;
      }
      
      if (record.dueDate != null) {
        final daysUntilDue = record.dueDate!.difference(DateTime.now()).inDays;
        if (daysUntilDue <= 30 && daysUntilDue > 0) {
          _expiringCount++;
        }
      }
    }
  }

  void _filterRecords() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        // Search filter
        final matchesSearch = query.isEmpty ||
            record.title.toLowerCase().contains(query) ||
            (record.description?.toLowerCase().contains(query) ?? false) ||
            record.category.toLowerCase().contains(query) ||
            (record.parties?.any((p) => p.toLowerCase().contains(query)) ?? false) ||
            (record.reference?.toLowerCase().contains(query) ?? false) ||
            (record.tags?.any((t) => t.toLowerCase().contains(query)) ?? false) ||
            (record.notes?.toLowerCase().contains(query) ?? false);

        if (!matchesSearch) return false;

        // Category filter
        if (_selectedFilter != 'All') {
          return record.recordType.toString().split('.').last == _selectedFilter.toLowerCase() ||
                 record.category == _selectedFilter;
        }
        
        return true;
      }).toList();

      // Sort by date (most recent first)
      _filteredRecords.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: const AddRecordDialog(),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _addNewRecord(value);
      }
    });
  }

  void _addNewRecord(Map<String, dynamic> data) {
    setState(() {
      final now = DateTime.now();
      final newRecord = RecordItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['title'],
        description: data['description'],
        recordType: data['recordType'],
        category: data['category'],
        amount: data['amount'],
        currency: data['currency'],
        date: data['date'],
        dueDate: data['dueDate'],
        parties: data['parties'] != null 
            ? (data['parties'] as String).split(',').map((e) => e.trim()).toList()
            : [],
        location: data['location'],
        reference: data['reference'],
        tags: data['tags'] != null 
            ? (data['tags'] as String).split(',').map((e) => e.trim()).toList()
            : [],
        attachments: [],
        notes: data['notes'],
        status: data['status'] ?? RecordStatus.active,
        createdBy: 'Current User',
        createdAt: now,
        modifiedBy: 'Current User',
        modifiedAt: now,
        color: _getCategoryColor(data['recordType']),
        icon: _getCategoryIcon(data['recordType']),
        isFavorite: data['isFavorite'] ?? false,
      );
      
      _allRecords.insert(0, newRecord);
      _calculateStats();
      _filterRecords();
    });

    _showSnackBar('Record added successfully', isError: false);
  }

  IconData _getCategoryIcon(RecordType type) {
    switch (type) {
      case RecordType.financial:
        return Icons.attach_money;
      case RecordType.legal:
        return Icons.gavel;
      case RecordType.medical:
        return Icons.medical_services;
      case RecordType.property:
        return Icons.home;
      case RecordType.education:
        return Icons.school;
      case RecordType.other:
        return Icons.description;
    }
  }

  Color _getCategoryColor(RecordType type) {
    switch (type) {
      case RecordType.financial:
        return Colors.green;
      case RecordType.legal:
        return Colors.red;
      case RecordType.medical:
        return Colors.blue;
      case RecordType.property:
        return Colors.orange;
      case RecordType.education:
        return Colors.purple;
      case RecordType.other:
        return Colors.grey;
    }
  }

  String _formatCurrency(double? amount, String? currency) {
    if (amount == null) return '';
    final formatter = NumberFormat.currency(
      symbol: currency == 'USD' ? '\$' : currency,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  void _showRecordDetails(RecordItem record) {
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
                      // Header with icon and title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: record.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              record.icon,
                              color: record.color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.title,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
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
                                        color: record.color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        record.recordType.toString().split('.').last,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11,
                                          color: record.color,
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
                                        color: _getStatusColor(record.status).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        record.status.toString().split('.').last,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11,
                                          color: _getStatusColor(record.status),
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

                      // Amount if exists
                      if (record.amount != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                record.color.withOpacity(0.2),
                                record.color.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: record.color.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Amount',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatCurrency(record.amount, record.currency),
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: record.color,
                                ),
                              ),
                              if (record.category.contains('Sale') || record.category.contains('Income'))
                                Text(
                                  'Income',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: Colors.green,
                                  ),
                                )
                              else if (record.amount! > 0)
                                Text(
                                  'Expense',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Date
                      _buildInfoSection(
                        'Date',
                        Icons.calendar_today,
                        _formatDate(record.date),
                      ),

                      if (record.dueDate != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoSection(
                          'Due Date',
                          Icons.event,
                          '${_formatDate(record.dueDate!)} (${_getDueDateStatus(record.dueDate!)})',
                          statusColor: _getDueDateColor(record.dueDate!),
                        ),
                      ],

                      if (record.location.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoSection(
                          'Location',
                          Icons.location_on,
                          record.location,
                        ),
                      ],

                      if (record.parties != null && record.parties!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildPartiesSection(record.parties!),
                      ],

                      if (record.reference != null && record.reference!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoSection(
                          'Reference',
                          Icons.numbers,
                          record.reference!,
                          canCopy: true,
                          onCopy: () => _copyToClipboard(record.reference!, 'Reference'),
                        ),
                      ],

                      if (record.description != null && record.description!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoSection(
                          'Description',
                          Icons.description,
                          record.description!,
                          isMultiline: true,
                        ),
                      ],

                      if (record.tags != null && record.tags!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildTagsSection(record.tags!),
                      ],

                      if (record.notes != null && record.notes!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoSection(
                          'Notes',
                          Icons.note,
                          record.notes!,
                          isMultiline: true,
                        ),
                      ],

                      if (record.attachments.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildAttachmentsSection(record.attachments),
                      ],

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildRecordActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.pop(context);
                                _showEditRecordDialog(record);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRecordActionButton(
                              icon: Icons.share,
                              label: 'Share',
                              color: Colors.green,
                              onTap: () {
                                Navigator.pop(context);
                                _showShareRecordDialog(record);
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildRecordActionButton(
                              icon: Icons.favorite,
                              label: record.isFavorite ? 'Unfavorite' : 'Favorite',
                              color: Colors.red,
                              onTap: () {
                                setState(() {
                                  record.isFavorite = !record.isFavorite;
                                });
                                Navigator.pop(context);
                                _showSnackBar(
                                  record.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                                  isError: false,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRecordActionButton(
                              icon: Icons.delete_outline,
                              label: 'Delete',
                              color: Colors.red,
                              onTap: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(record);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Metadata
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Created by ${record.createdBy} on ${_formatDate(record.createdAt)}',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Last modified by ${record.modifiedBy} ${_formatRelativeTime(record.modifiedAt)}',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white38,
                              ),
                            ),
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

  Widget _buildInfoSection(
    String label,
    IconData icon,
    String value, {
    bool isMultiline = false,
    bool canCopy = false,
    VoidCallback? onCopy,
    Color? statusColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
              color: statusColor ?? Colors.blue.shade300,
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
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: statusColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy && onCopy != null)
            IconButton(
              onPressed: onCopy,
              icon: Icon(
                Icons.copy,
                size: 18,
                color: Colors.white60,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartiesSection(List<String> parties) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Parties (${parties.length})',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...parties.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key < parties.length - 1 ? 8 : 0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tag,
                  size: 16,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tags',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.orange.shade200,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(List<String> attachments) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.attach_file,
                  size: 16,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Attachments (${attachments.length})',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...attachments.map((file) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getFileIcon(file),
                    size: 16,
                    color: Colors.purple.shade300,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showSnackBar('Downloading $file', isError: false),
                    icon: Icon(
                      Icons.download,
                      size: 16,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  IconData _getFileIcon(String filename) {
    if (filename.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (filename.endsWith('.jpg') || filename.endsWith('.png')) return Icons.image;
    if (filename.endsWith('.doc') || filename.endsWith('.docx')) return Icons.description;
    return Icons.insert_drive_file;
  }

  Widget _buildRecordActionButton({
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
            ),
          ],
        ),
      ),
    );
  }

  void _showEditRecordDialog(RecordItem record) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: EditRecordDialog(record: record),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _updateRecord(record.id, value);
      }
    });
  }

  void _updateRecord(String id, Map<String, dynamic> data) {
    setState(() {
      final index = _allRecords.indexWhere((r) => r.id == id);
      if (index != -1) {
        final oldRecord = _allRecords[index];
        _allRecords[index] = RecordItem(
          id: oldRecord.id,
          title: data['title'] ?? oldRecord.title,
          description: data['description'] ?? oldRecord.description,
          recordType: data['recordType'] ?? oldRecord.recordType,
          category: data['category'] ?? oldRecord.category,
          amount: data['amount'] ?? oldRecord.amount,
          currency: data['currency'] ?? oldRecord.currency,
          date: data['date'] ?? oldRecord.date,
          dueDate: data['dueDate'] ?? oldRecord.dueDate,
          parties: data['parties'] != null 
              ? (data['parties'] as String).split(',').map((e) => e.trim()).toList()
              : oldRecord.parties,
          location: data['location'] ?? oldRecord.location,
          reference: data['reference'] ?? oldRecord.reference,
          tags: data['tags'] != null 
              ? (data['tags'] as String).split(',').map((e) => e.trim()).toList()
              : oldRecord.tags,
          attachments: oldRecord.attachments,
          notes: data['notes'] ?? oldRecord.notes,
          status: data['status'] ?? oldRecord.status,
          createdBy: oldRecord.createdBy,
          createdAt: oldRecord.createdAt,
          modifiedBy: 'Current User',
          modifiedAt: DateTime.now(),
          color: oldRecord.color,
          icon: oldRecord.icon,
          isFavorite: data['isFavorite'] ?? oldRecord.isFavorite,
        );
        _calculateStats();
        _filterRecords();
      }
    });
    _showSnackBar('Record updated successfully', isError: false);
  }

  void _showShareRecordDialog(RecordItem record) {
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
                      'Share "${record.title}"',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Share options
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildShareOption(
                          icon: Icons.people,
                          label: 'Family',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Shared with family', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.email,
                          label: 'Email',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening email...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.message,
                          label: 'Message',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening messages...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.print,
                          label: 'Print',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Preparing to print...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.picture_as_pdf,
                          label: 'PDF',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Generating PDF...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.copy,
                          label: 'Copy',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pop(context);
                            _copyRecordDetails(record);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.cloud_download,
                          label: 'Export',
                          color: Colors.cyan,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Exporting data...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.more_horiz,
                          label: 'More',
                          color: Colors.grey,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('More options...', isError: false);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
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

  Widget _buildShareOption({
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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

  void _copyRecordDetails(RecordItem record) {
    String details = '''
Record: ${record.title}
Type: ${record.recordType}
Category: ${record.category}
Date: ${_formatDate(record.date)}
''';

    if (record.amount != null) {
      details += 'Amount: ${_formatCurrency(record.amount, record.currency)}\n';
    }
    
    if (record.location.isNotEmpty) {
      details += 'Location: ${record.location}\n';
    }
    
    if (record.reference != null) {
      details += 'Reference: ${record.reference}\n';
    }
    
    if (record.description != null) {
      details += 'Description: ${record.description}\n';
    }

    // In real app: Clipboard.setData(ClipboardData(text: details));
    _showSnackBar('Record details copied to clipboard', isError: false);
  }

  void _showDeleteConfirmation(RecordItem record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1E33),
        title: Text(
          'Delete Record',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${record.title}"? This action cannot be undone.',
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
                _allRecords.removeWhere((r) => r.id == record.id);
                _calculateStats();
                _filterRecords();
              });
              Navigator.pop(context);
              _showSnackBar('Record deleted', isError: false);
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

  void _copyToClipboard(String text, String label) {
    // In real app: Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('$label copied to clipboard', isError: false);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getDueDateStatus(DateTime dueDate) {
    final days = dueDate.difference(DateTime.now()).inDays;
    if (days < 0) return 'Overdue';
    if (days == 0) return 'Due today';
    if (days <= 7) return 'Due in $days days';
    return 'Due in $days days';
  }

  Color _getDueDateColor(DateTime dueDate) {
    final days = dueDate.difference(DateTime.now()).inDays;
    if (days < 0) return Colors.red;
    if (days <= 7) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(RecordStatus status) {
    switch (status) {
      case RecordStatus.active:
        return Colors.green;
      case RecordStatus.pending:
        return Colors.orange;
      case RecordStatus.completed:
        return Colors.blue;
      case RecordStatus.cancelled:
        return Colors.red;
    }
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
                            'Records',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredRecords.length} records • Family archive',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add record button
                    GestureDetector(
                      onTap: _showAddRecordDialog,
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

              // Summary Cards
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSummaryCard(
                        title: 'Total Income',
                        value: '\$${_totalIncome.toStringAsFixed(0)}',
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        title: 'Total Expenses',
                        value: '\$${_totalExpenses.toStringAsFixed(0)}',
                        icon: Icons.trending_down,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        title: 'Pending',
                        value: '$_pendingCount',
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        title: 'Expiring Soon',
                        value: '$_expiringCount',
                        icon: Icons.timer,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              // Search and filters
              Container(
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
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search records...',
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
                                  _filterRecords();
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

              const SizedBox(height: 16),

              // Records list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredRecords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 80,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No records found',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add your first record to get started',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _showAddRecordDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Record'),
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
                            itemCount: _filteredRecords.length,
                            itemBuilder: (context, index) {
                              final record = _filteredRecords[index];
                              return FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildRecordTile(record),
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

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordTile(RecordItem record) {
    final isOverdue = record.dueDate != null && record.dueDate!.isBefore(DateTime.now());
    final isDueSoon = record.dueDate != null && 
                     !isOverdue && 
                     record.dueDate!.difference(DateTime.now()).inDays <= 7;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue
              ? Colors.red.withOpacity(0.5)
              : isDueSoon
                  ? Colors.orange.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
          width: isOverdue || isDueSoon ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showRecordDetails(record),
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
                  color: record.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  record.icon,
                  color: record.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Record details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            record.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (record.isFavorite)
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
                      record.category,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: record.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 10,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(record.date),
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                        ),
                        if (record.amount != null) ...[
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
                            _formatCurrency(record.amount, record.currency),
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: record.category.contains('Sale') || 
                                     record.category.contains('Income')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (record.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 10,
                            color: isOverdue
                                ? Colors.red
                                : isDueSoon
                                    ? Colors.orange
                                    : Colors.white38,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDueDateStatus(record.dueDate!),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: isOverdue
                                  ? Colors.red
                                  : isDueSoon
                                      ? Colors.orange
                                      : Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(record.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  record.status.toString().split('.').last,
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    color: _getStatusColor(record.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Record Dialog
class AddRecordDialog extends StatefulWidget {
  const AddRecordDialog({super.key});

  @override
  State<AddRecordDialog> createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();
  final _partiesController = TextEditingController();
  final _referenceController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  
  RecordType _selectedType = RecordType.financial;
  String _selectedCategory = 'Payment';
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedDueDate;
  RecordStatus _selectedStatus = RecordStatus.active;
  bool _isFavorite = false;
  
  final List<String> _financialCategories = [
    'Payment', 'Income', 'Expense', 'Rent', 'Mortgage', 
    'Utilities', 'Insurance', 'Taxes', 'Investment', 'Loan'
  ];
  
  final List<String> _legalCategories = [
    'Contract', 'Agreement', 'Will', 'Certificate', 'License', 'Permit'
  ];
  
  final List<String> _medicalCategories = [
    'Insurance', 'Prescription', 'Vaccination', 'Test Result', 
    'Medical History', 'Appointment'
  ];
  
  final List<String> _propertyCategories = [
    'Deed', 'Title', 'Insurance', 'Taxes', 'Maintenance', 'Renovation'
  ];
  
  final List<String> _educationCategories = [
    'Tuition', 'Transcript', 'Certificate', 'Diploma', 'Test Score', 'Application'
  ];
  
  final List<String> _otherCategories = [
    'Receipt', 'Warranty', 'Manual', 'Correspondence', 'Other'
  ];

  List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _partiesController.dispose();
    _referenceController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<String> _getCategoriesForType() {
    switch (_selectedType) {
      case RecordType.financial:
        return _financialCategories;
      case RecordType.legal:
        return _legalCategories;
      case RecordType.medical:
        return _medicalCategories;
      case RecordType.property:
        return _propertyCategories;
      case RecordType.education:
        return _educationCategories;
      case RecordType.other:
        return _otherCategories;
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
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
        _selectedDueDate = picked;
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
                    color: Colors.blue.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.note_add,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Add New Record',
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
                      labelText: 'Record Title *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., House Sale, Medical Bill, Contract',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.title, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter record title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Record Type
                  DropdownButtonFormField<RecordType>(
                    value: _selectedType,
                    dropdownColor: const Color(0xFF0B1E33),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Record Type *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.category, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    items: RecordType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                        _selectedCategory = _getCategoriesForType().first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    dropdownColor: const Color(0xFF0B1E33),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.list, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    items: _getCategoriesForType().map((category) {
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

                  // Date
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date *',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
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

                  // Amount (optional)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountController,
                          style: GoogleFonts.montserrat(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount (Optional)',
                            labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                            hintText: '0.00',
                            hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                            prefixIcon: Icon(Icons.attach_money, color: Colors.blue.shade300),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue.shade300),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          dropdownColor: const Color(0xFF0B1E33),
                          style: GoogleFonts.montserrat(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Currency',
                            labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue.shade300),
                            ),
                          ),
                          items: _currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Due Date (optional)
                  InkWell(
                    onTap: _selectDueDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event, color: Colors.orange.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due Date (Optional)',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  _selectedDueDate == null
                                      ? 'Not set'
                                      : '${_selectedDueDate!.year}-${_selectedDueDate!.month.toString().padLeft(2, '0')}-${_selectedDueDate!.day.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: _selectedDueDate == null
                                        ? Colors.white38
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedDueDate != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedDueDate = null;
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.white60, size: 16),
                            ),
                          Icon(Icons.arrow_drop_down, color: Colors.white60),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., City Hall, Hospital, Online',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Parties
                  TextFormField(
                    controller: _partiesController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Parties Involved',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Comma separated names',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.people, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reference
                  TextFormField(
                    controller: _referenceController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Reference Number',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., Invoice #, Contract #',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.numbers, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Brief description...',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.description, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  TextFormField(
                    controller: _tagsController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tags',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Comma separated tags',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.tag, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<RecordStatus>(
                    value: _selectedStatus,
                    dropdownColor: const Color(0xFF0B1E33),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Status',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.info, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    items: RecordStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Additional Notes',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'Any extra information...',
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
                  const SizedBox(height: 16),

                  // Favorite
                  Row(
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
                      const SizedBox(width: 8),
                      Text(
                        'Mark as favorite',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
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
                          'description': _descriptionController.text,
                          'recordType': _selectedType,
                          'category': _selectedCategory,
                          'amount': double.tryParse(_amountController.text),
                          'currency': _selectedCurrency,
                          'date': _selectedDate,
                          'dueDate': _selectedDueDate,
                          'parties': _partiesController.text,
                          'location': _locationController.text,
                          'reference': _referenceController.text,
                          'tags': _tagsController.text,
                          'notes': _notesController.text,
                          'status': _selectedStatus,
                          'isFavorite': _isFavorite,
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
                    child: const Text('Create Record'),
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
                    'All records are encrypted and stored securely',
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

// Edit Record Dialog
class EditRecordDialog extends StatefulWidget {
  final RecordItem record;

  const EditRecordDialog({super.key, required this.record});

  @override
  State<EditRecordDialog> createState() => _EditRecordDialogState();
}

class _EditRecordDialogState extends State<EditRecordDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _locationController;
  late final TextEditingController _partiesController;
  late final TextEditingController _referenceController;
  late final TextEditingController _tagsController;
  late final TextEditingController _notesController;
  
  late RecordType _selectedType;
  late String _selectedCategory;
  late String _selectedCurrency;
  late DateTime _selectedDate;
  late DateTime? _selectedDueDate;
  late RecordStatus _selectedStatus;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.record.title);
    _descriptionController = TextEditingController(text: widget.record.description);
    _amountController = TextEditingController(
      text: widget.record.amount?.toString() ?? '',
    );
    _locationController = TextEditingController(text: widget.record.location);
    _partiesController = TextEditingController(
      text: widget.record.parties?.join(', ') ?? '',
    );
    _referenceController = TextEditingController(text: widget.record.reference);
    _tagsController = TextEditingController(
      text: widget.record.tags?.join(', ') ?? '',
    );
    _notesController = TextEditingController(text: widget.record.notes);
    
    _selectedType = widget.record.recordType;
    _selectedCategory = widget.record.category;
    _selectedCurrency = widget.record.currency ?? 'USD';
    _selectedDate = widget.record.date;
    _selectedDueDate = widget.record.dueDate;
    _selectedStatus = widget.record.status;
    _isFavorite = widget.record.isFavorite;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _partiesController.dispose();
    _referenceController.dispose();
    _tagsController.dispose();
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
                    'Edit Record',
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

            // Form (simplified for edit - similar fields as add)
            Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Record Title *',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.title, color: Colors.blue.shade300),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Display type and category (read-only in edit for simplicity)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade300, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type: ${_selectedType.toString().split('.').last}',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Category: $_selectedCategory',
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
                const SizedBox(height: 16),

                TextFormField(
                  controller: _amountController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.blue.shade300),
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
                  controller: _locationController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Location',
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
                const SizedBox(height: 16),

                TextFormField(
                  controller: _partiesController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Parties Involved',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.people, color: Colors.blue.shade300),
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
                  controller: _referenceController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Reference Number',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.numbers, color: Colors.blue.shade300),
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
                  controller: _descriptionController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.description, color: Colors.blue.shade300),
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
                  controller: _tagsController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    prefixIcon: Icon(Icons.tag, color: Colors.blue.shade300),
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
                const SizedBox(height: 16),

                Row(
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
                    const SizedBox(width: 8),
                    Text(
                      'Mark as favorite',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
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
                        'description': _descriptionController.text,
                        'amount': double.tryParse(_amountController.text),
                        'currency': _selectedCurrency,
                        'date': _selectedDate,
                        'dueDate': _selectedDueDate,
                        'location': _locationController.text,
                        'parties': _partiesController.text,
                        'reference': _referenceController.text,
                        'tags': _tagsController.text,
                        'notes': _notesController.text,
                        'status': _selectedStatus,
                        'isFavorite': _isFavorite,
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
                    child: const Text('Update Record'),
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

enum RecordType {
  financial,
  legal,
  medical,
  property,
  education,
  other
}

enum RecordStatus {
  active,
  pending,
  completed,
  cancelled
}

class RecordItem {
  final String id;
  final String title;
  final String? description;
  final RecordType recordType;
  final String category;
  final double? amount;
  final String? currency;
  final DateTime date;
  final DateTime? dueDate;
  final List<String>? parties;
  final String location;
  final String? reference;
  final List<String>? tags;
  final List<String> attachments;
  final String? notes;
  final RecordStatus status;
  final String createdBy;
  final DateTime createdAt;
  final String modifiedBy;
  final DateTime modifiedAt;
  final Color color;
  final IconData icon;
  bool isFavorite;

  RecordItem({
    required this.id,
    required this.title,
    this.description,
    required this.recordType,
    required this.category,
    this.amount,
    this.currency,
    required this.date,
    this.dueDate,
    this.parties,
    required this.location,
    this.reference,
    this.tags,
    required this.attachments,
    this.notes,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.modifiedBy,
    required this.modifiedAt,
    required this.color,
    required this.icon,
    required this.isFavorite,
  });
}