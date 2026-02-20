import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<EventItem> _allEvents = [];
  List<EventItem> _filteredEvents = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'Upcoming';
  final List<String> _filters = ['Upcoming', 'Today', 'This Week', 'This Month', 'Recurring', 'Past'];
  
  // Calendar view mode
  bool _isCalendarView = false;
  DateTime _selectedDate = DateTime.now();

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
    
    // Load mock events
    _loadEvents();
    
    _searchController.addListener(_filterEvents);
  }

  void _loadEvents() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allEvents.addAll([
          EventItem(
            id: '1',
            title: 'Sarah\'s Birthday Party',
            description: 'Celebrating Sarah\'s 10th birthday with family and friends',
            startDate: DateTime.now().add(const Duration(days: 5)),
            startTime: '15:00',
            endDate: DateTime.now().add(const Duration(days: 5)),
            endTime: '19:00',
            location: 'Home - 123 Main St',
            organizer: 'John Doe',
            category: EventCategory.birthday,
            color: Colors.pink,
            icon: Icons.cake,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['John', 'Sarah', 'Mike', 'Emma', 'Grandma'],
            reminders: [1, 3, 7], // days before
            attachments: [],
            notes: 'Bring cake and decorations',
            status: EventStatus.confirmed,
            createdBy: 'John Doe',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
            modifiedBy: 'John Doe',
            modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          EventItem(
            id: '2',
            title: 'Family Dinner',
            description: 'Weekly family dinner - Italian night',
            startDate: DateTime.now().add(const Duration(days: 2)),
            startTime: '18:30',
            endDate: DateTime.now().add(const Duration(days: 2)),
            endTime: '21:00',
            location: 'Home',
            organizer: 'Mom',
            category: EventCategory.family,
            color: Colors.orange,
            icon: Icons.dinner_dining,
            isRecurring: true,
            recurringPattern: 'Weekly',
            attendees: ['All Family Members'],
            reminders: [1],
            attachments: [],
            notes: 'Sarah is bringing dessert',
            status: EventStatus.confirmed,
            createdBy: 'Mom',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            modifiedBy: 'Mom',
            modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          EventItem(
            id: '3',
            title: 'School Parent-Teacher Meeting',
            description: 'Quarterly meeting with teachers',
            startDate: DateTime.now().add(const Duration(days: 10)),
            startTime: '16:00',
            endDate: DateTime.now().add(const Duration(days: 10)),
            endTime: '18:00',
            location: 'Elementary School',
            organizer: 'School',
            category: EventCategory.school,
            color: Colors.blue,
            icon: Icons.school,
            isRecurring: true,
            recurringPattern: 'Quarterly',
            attendees: ['Parents', 'Teachers'],
            reminders: [2, 7],
            attachments: ['agenda.pdf'],
            notes: 'Review Sarah\'s progress',
            status: EventStatus.confirmed,
            createdBy: 'School Admin',
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
            modifiedBy: 'School Admin',
            modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          EventItem(
            id: '4',
            title: 'Doctor Appointment',
            description: 'Annual checkup for Mike',
            startDate: DateTime.now().add(const Duration(days: 3)),
            startTime: '10:30',
            endDate: DateTime.now().add(const Duration(days: 3)),
            endTime: '11:30',
            location: 'City Medical Center',
            organizer: 'Dr. Wilson',
            category: EventCategory.medical,
            color: Colors.green,
            icon: Icons.medical_services,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['Mike', 'Parent'],
            reminders: [1, 3],
            attachments: ['insurance_card.jpg'],
            notes: 'Bring insurance card',
            status: EventStatus.confirmed,
            createdBy: 'Mom',
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            modifiedBy: 'Mom',
            modifiedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          EventItem(
            id: '5',
            title: 'Christmas Eve Dinner',
            description: 'Family gathering for Christmas Eve',
            startDate: DateTime(DateTime.now().year, 12, 24),
            startTime: '17:00',
            endDate: DateTime(DateTime.now().year, 12, 24),
            endTime: '23:00',
            location: 'Grandma\'s House',
            organizer: 'Grandma',
            category: EventCategory.holiday,
            color: Colors.red,
            icon: Icons.celebration,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['Extended Family'],
            reminders: [7, 30],
            attachments: ['menu.pdf'],
            notes: 'Secret Santa gift exchange',
            status: EventStatus.confirmed,
            createdBy: 'Grandma',
            createdAt: DateTime.now().subtract(const Duration(days: 365)),
            modifiedBy: 'Grandma',
            modifiedAt: DateTime.now().subtract(const Duration(days: 50)),
          ),
          EventItem(
            id: '6',
            title: 'Weekend Camping Trip',
            description: 'Family camping at Lake Tahoe',
            startDate: DateTime.now().add(const Duration(days: 15)),
            startTime: '09:00',
            endDate: DateTime.now().add(const Duration(days: 17)),
            endTime: '18:00',
            location: 'Lake Tahoe Campground',
            organizer: 'Dad',
            category: EventCategory.vacation,
            color: Colors.teal,
            icon: Icons.beach_access,
            isRecurring: false,
            recurringPattern: null,
            attendees: ['All Family Members'],
            reminders: [3, 7, 14],
            attachments: ['packing_list.pdf', 'reservation.pdf'],
            notes: 'Bring camping gear and food',
            status: EventStatus.confirmed,
            createdBy: 'Dad',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            modifiedBy: 'Dad',
            modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          EventItem(
            id: '7',
            title: 'Dentist Appointment - Emma',
            description: 'Regular checkup and cleaning',
            startDate: DateTime.now().add(const Duration(days: 7)),
            startTime: '14:00',
            endDate: DateTime.now().add(const Duration(days: 7)),
            endTime: '15:00',
            location: 'Sunrise Dental Clinic',
            organizer: 'Dr. Brown',
            category: EventCategory.medical,
            color: Colors.green,
            icon: Icons.medical_services,
            isRecurring: true,
            recurringPattern: '6 months',
            attendees: ['Emma', 'Parent'],
            reminders: [1, 3],
            attachments: [],
            notes: 'Previous x-rays needed',
            status: EventStatus.confirmed,
            createdBy: 'Mom',
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            modifiedBy: 'Mom',
            modifiedAt: DateTime.now().subtract(const Duration(days: 10)),
          ),
          EventItem(
            id: '8',
            title: 'Movie Night',
            description: 'Family movie night - New releases',
            startDate: DateTime.now().add(const Duration(days: 4)),
            startTime: '19:00',
            endDate: DateTime.now().add(const Duration(days: 4)),
            endTime: '22:00',
            location: 'Home Theater',
            organizer: 'Kids',
            category: EventCategory.entertainment,
            color: Colors.purple,
            icon: Icons.movie,
            isRecurring: true,
            recurringPattern: 'Weekly',
            attendees: ['All Family Members'],
            reminders: [1],
            attachments: [],
            notes: 'Kids choosing the movie',
            status: EventStatus.confirmed,
            createdBy: 'Sarah',
            createdAt: DateTime.now().subtract(const Duration(days: 14)),
            modifiedBy: 'Sarah',
            modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          EventItem(
            id: '9',
            title: 'Yard Sale',
            description: 'Spring cleaning yard sale',
            startDate: DateTime.now().add(const Duration(days: 12)),
            startTime: '08:00',
            endDate: DateTime.now().add(const Duration(days: 12)),
            endTime: '15:00',
            location: 'Front Yard',
            organizer: 'Family',
            category: EventCategory.family,
            color: Colors.brown,
            icon: Icons.sell,
            isRecurring: false,
            recurringPattern: null,
            attendees: ['All Family Members'],
            reminders: [2, 5],
            attachments: ['price_list.pdf'],
            notes: 'Price items beforehand',
            status: EventStatus.pending,
            createdBy: 'Dad',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            modifiedBy: 'Dad',
            modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          EventItem(
            id: '10',
            title: 'Emma\'s Piano Recital',
            description: 'End of year piano performance',
            startDate: DateTime.now().add(const Duration(days: 20)),
            startTime: '18:00',
            endDate: DateTime.now().add(const Duration(days: 20)),
            endTime: '20:00',
            location: 'Music Academy Hall',
            organizer: 'Music Academy',
            category: EventCategory.school,
            color: Colors.indigo,
            icon: Icons.piano,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['Emma', 'Family', 'Friends'],
            reminders: [3, 7, 14],
            attachments: ['invitation.pdf'],
            notes: 'Formal attire recommended',
            status: EventStatus.confirmed,
            createdBy: 'Emma',
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            modifiedBy: 'Emma',
            modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          EventItem(
            id: '11',
            title: 'Back to School Shopping',
            description: 'Buy supplies for new school year',
            startDate: DateTime.now().add(const Duration(days: 25)),
            startTime: '10:00',
            endDate: DateTime.now().add(const Duration(days: 25)),
            endTime: '16:00',
            location: 'Mall',
            organizer: 'Mom',
            category: EventCategory.shopping,
            color: Colors.amber,
            icon: Icons.shopping_bag,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['Kids', 'Mom'],
            reminders: [2, 5],
            attachments: ['school_supplies_list.pdf'],
            notes: 'Check school website for requirements',
            status: EventStatus.confirmed,
            createdBy: 'Mom',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            modifiedBy: 'Mom',
            modifiedAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
          EventItem(
            id: '12',
            title: 'Tax Deadline',
            description: 'File family taxes',
            startDate: DateTime(DateTime.now().year, 4, 15),
            startTime: '23:59',
            endDate: DateTime(DateTime.now().year, 4, 15),
            endTime: '23:59',
            location: 'Online',
            organizer: 'Dad',
            category: EventCategory.important,
            color: Colors.red,
            icon: Icons.request_page,
            isRecurring: true,
            recurringPattern: 'Yearly',
            attendees: ['Dad', 'Accountant'],
            reminders: [7, 14, 30],
            attachments: ['tax_documents.zip'],
            notes: 'Gather all W-2s and receipts',
            status: EventStatus.confirmed,
            createdBy: 'Dad',
            createdAt: DateTime.now().subtract(const Duration(days: 100)),
            modifiedBy: 'Dad',
            modifiedAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ]);
        
        _filterEvents();
        _isLoading = false;
      });
    });
  }

  void _filterEvents() {
    String query = _searchController.text.toLowerCase();
    final now = DateTime.now();
    
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        // Search filter
        final matchesSearch = query.isEmpty ||
            event.title.toLowerCase().contains(query) ||
            (event.description?.toLowerCase().contains(query) ?? false) ||
            event.location.toLowerCase().contains(query) ||
            event.organizer.toLowerCase().contains(query) ||
            (event.attendees?.any((a) => a.toLowerCase().contains(query)) ?? false);

        if (!matchesSearch) return false;

        // Date filters
        switch (_selectedFilter) {
          case 'Today':
            return _isSameDay(event.startDate, now);
          case 'This Week':
            final weekEnd = now.add(const Duration(days: 7));
            return event.startDate.isAfter(now.subtract(const Duration(days: 1))) && 
                   event.startDate.isBefore(weekEnd);
          case 'This Month':
            return event.startDate.year == now.year && 
                   event.startDate.month == now.month;
          case 'Upcoming':
            return event.startDate.isAfter(now.subtract(const Duration(days: 1)));
          case 'Past':
            return event.startDate.isBefore(now);
          case 'Recurring':
            return event.isRecurring;
          default:
            return true;
        }
      }).toList();

      // Sort by date
      _filteredEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: const AddEventDialog(),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _addNewEvent(value);
      }
    });
  }

  void _addNewEvent(Map<String, dynamic> data) {
    setState(() {
      final now = DateTime.now();
      final newEvent = EventItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['title'],
        description: data['description'],
        startDate: data['startDate'],
        startTime: data['startTime'],
        endDate: data['endDate'],
        endTime: data['endTime'],
        location: data['location'],
        organizer: 'Current User',
        category: data['category'],
        color: _getCategoryColor(data['category']),
        icon: _getCategoryIcon(data['category']),
        isRecurring: data['isRecurring'],
        recurringPattern: data['recurringPattern'],
        attendees: data['attendees'] != null 
            ? (data['attendees'] as String).split(',').map((e) => e.trim()).toList()
            : [],
        reminders: data['reminders'] ?? [1],
        attachments: [],
        notes: data['notes'],
        status: EventStatus.confirmed,
        createdBy: 'Current User',
        createdAt: now,
        modifiedBy: 'Current User',
        modifiedAt: now,
      );
      
      _allEvents.insert(0, newEvent);
      _filterEvents();
    });

    _showSnackBar('Event added successfully', isError: false);
  }

  IconData _getCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.birthday:
        return Icons.cake;
      case EventCategory.family:
        return Icons.family_restroom;
      case EventCategory.holiday:
        return Icons.celebration;
      case EventCategory.vacation:
        return Icons.beach_access;
      case EventCategory.medical:
        return Icons.medical_services;
      case EventCategory.school:
        return Icons.school;
      case EventCategory.work:
        return Icons.work;
      case EventCategory.shopping:
        return Icons.shopping_cart;
      case EventCategory.entertainment:
        return Icons.movie;
      case EventCategory.important:
        return Icons.priority_high;
      case EventCategory.other:
        return Icons.event;
    }
  }

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.birthday:
        return Colors.pink;
      case EventCategory.family:
        return Colors.orange;
      case EventCategory.holiday:
        return Colors.red;
      case EventCategory.vacation:
        return Colors.teal;
      case EventCategory.medical:
        return Colors.green;
      case EventCategory.school:
        return Colors.blue;
      case EventCategory.work:
        return Colors.purple;
      case EventCategory.shopping:
        return Colors.amber;
      case EventCategory.entertainment:
        return Colors.indigo;
      case EventCategory.important:
        return Colors.red;
      case EventCategory.other:
        return Colors.grey;
    }
  }

  void _showEventDetails(EventItem event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                              color: event.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              event.icon,
                              color: event.color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: event.color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event.category.toString().split('.').last,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: event.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Date and Time
                      _buildInfoSection(
                        'When',
                        Icons.calendar_today,
                        _formatEventDateTime(event),
                      ),

                      const SizedBox(height: 16),

                      // Location
                      _buildInfoSection(
                        'Where',
                        Icons.location_on,
                        event.location,
                      ),

                      const SizedBox(height: 16),

                      // Organizer
                      _buildInfoSection(
                        'Organized by',
                        Icons.person,
                        event.organizer,
                      ),

                      if (event.description != null && event.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Description',
                          Icons.description,
                          event.description!,
                          isMultiline: true,
                        ),
                      ],

                      if (event.attendees != null && event.attendees!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildAttendeesSection(event.attendees!),
                      ],

                      if (event.notes != null && event.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Notes',
                          Icons.note,
                          event.notes!,
                          isMultiline: true,
                        ),
                      ],

                      if (event.reminders.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildRemindersSection(event.reminders),
                      ],

                      if (event.isRecurring) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Repeats',
                          Icons.repeat,
                          event.recurringPattern ?? 'Regularly',
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildEventActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.pop(context);
                                _showEditEventDialog(event);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEventActionButton(
                              icon: Icons.share,
                              label: 'Share',
                              color: Colors.green,
                              onTap: () {
                                Navigator.pop(context);
                                _showShareEventDialog(event);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEventActionButton(
                              icon: Icons.delete_outline,
                              label: 'Delete',
                              color: Colors.red,
                              onTap: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(event);
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
                              'Created by ${event.createdBy}',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Last modified ${_formatRelativeTime(event.modifiedAt)}',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
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

  Widget _buildInfoSection(String label, IconData icon, String value, {bool isMultiline = false}) {
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
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 2),
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
        ],
      ),
    );
  }

  Widget _buildAttendeesSection(List<String> attendees) {
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
                'Attendees (${attendees.length})',
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
            children: attendees.map((attendee) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  attendee,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.green.shade200,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection(List<int> reminders) {
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
                  Icons.notifications,
                  size: 16,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Reminders',
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
            children: reminders.map((days) {
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
                  '$days day${days > 1 ? 's' : ''} before',
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

  Widget _buildEventActionButton({
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
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEventDialog(EventItem event) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: EditEventDialog(event: event),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        _updateEvent(event.id, value);
      }
    });
  }

  void _updateEvent(String id, Map<String, dynamic> data) {
    setState(() {
      final index = _allEvents.indexWhere((e) => e.id == id);
      if (index != -1) {
        final oldEvent = _allEvents[index];
        _allEvents[index] = EventItem(
          id: oldEvent.id,
          title: data['title'] ?? oldEvent.title,
          description: data['description'] ?? oldEvent.description,
          startDate: data['startDate'] ?? oldEvent.startDate,
          startTime: data['startTime'] ?? oldEvent.startTime,
          endDate: data['endDate'] ?? oldEvent.endDate,
          endTime: data['endTime'] ?? oldEvent.endTime,
          location: data['location'] ?? oldEvent.location,
          organizer: data['organizer'] ?? oldEvent.organizer,
          category: data['category'] ?? oldEvent.category,
          color: oldEvent.color,
          icon: oldEvent.icon,
          isRecurring: data['isRecurring'] ?? oldEvent.isRecurring,
          recurringPattern: data['recurringPattern'] ?? oldEvent.recurringPattern,
          attendees: data['attendees'] != null 
              ? (data['attendees'] as String).split(',').map((e) => e.trim()).toList()
              : oldEvent.attendees,
          reminders: data['reminders'] ?? oldEvent.reminders,
          attachments: oldEvent.attachments,
          notes: data['notes'] ?? oldEvent.notes,
          status: data['status'] ?? oldEvent.status,
          createdBy: oldEvent.createdBy,
          createdAt: oldEvent.createdAt,
          modifiedBy: 'Current User',
          modifiedAt: DateTime.now(),
        );
        _filterEvents();
      }
    });
    _showSnackBar('Event updated successfully', isError: false);
  }

  void _showShareEventDialog(EventItem event) {
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
                      'Share "${event.title}"',
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
                          icon: Icons.calendar_today,
                          label: 'Add to Calendar',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Added to calendar', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.copy,
                          label: 'Copy Details',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            _copyEventDetails(event);
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
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening messages...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.chat,
                          label: 'WhatsApp',
                          color: Colors.green.shade700,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening WhatsApp...', isError: false);
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

  void _copyEventDetails(EventItem event) {
    final details = '''
Event: ${event.title}
Date: ${_formatDate(event.startDate)} ${event.startTime}
Location: ${event.location}
Organizer: ${event.organizer}
Description: ${event.description ?? 'N/A'}
''';
    // In real app: Clipboard.setData(ClipboardData(text: details));
    _showSnackBar('Event details copied to clipboard', isError: false);
  }

  void _showDeleteConfirmation(EventItem event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1E33),
        title: Text(
          'Delete Event',
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
              'Are you sure you want to delete "${event.title}"?',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
              ),
            ),
            if (event.isRecurring) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    RadioListTile<bool>(
                      title: Text(
                        'Delete this event only',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      value: false,
                      groupValue: false,
                      onChanged: (value) {},
                      activeColor: Colors.orange,
                    ),
                    RadioListTile<bool>(
                      title: Text(
                        'Delete all future events',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      value: true,
                      groupValue: false,
                      onChanged: (value) {},
                      activeColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
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
                _allEvents.removeWhere((e) => e.id == event.id);
                _filterEvents();
              });
              Navigator.pop(context);
              _showSnackBar('Event deleted', isError: false);
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

  String _formatEventDateTime(EventItem event) {
    final startStr = '${_formatDate(event.startDate)} at ${event.startTime}';
    if (!_isSameDay(event.startDate, event.endDate)) {
      return '$startStr - ${_formatDate(event.endDate)} at ${event.endTime}';
    }
    return '$startStr - ${event.endTime}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) return 'Today';
    if (_isSameDay(date, now.add(const Duration(days: 1)))) return 'Tomorrow';
    
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
                            'Events',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredEvents.length} events • Family calendar',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // View toggle
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isCalendarView = !_isCalendarView;
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isCalendarView ? Icons.view_agenda : Icons.calendar_month,
                          size: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add event button
                    GestureDetector(
                      onTap: _showAddEventDialog,
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
                          hintText: 'Search events...',
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
                                  _filterEvents();
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

              // Events list/calendar
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredEvents.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 80,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No events found',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add your first event to get started',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _showAddEventDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Event'),
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
                        : _isCalendarView
                            ? _buildCalendarView()
                            : _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    // Simple calendar view - in a real app, you'd use a proper calendar package
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1).weekday;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month - 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left, color: Colors.white70),
                ),
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month + 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Expanded(
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.9,
            ),
            itemCount: 42, // 6 weeks
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOfMonth + 2;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Container(); // Empty cell
              }

              final date = DateTime(now.year, now.month, dayNumber);
              final dayEvents = _allEvents.where((e) => 
                _isSameDay(e.startDate, date)
              ).toList();

              return GestureDetector(
                onTap: () {
                  // Show events for this day
                  if (dayEvents.isNotEmpty) {
                    _showDayEvents(date, dayEvents);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: dayEvents.isNotEmpty
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isSameDay(date, DateTime.now())
                          ? Colors.blue
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: dayEvents.isNotEmpty
                              ? Colors.blue.shade200
                              : Colors.white70,
                          fontWeight: _isSameDay(date, DateTime.now())
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (dayEvents.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDayEvents(DateTime date, List<EventItem> events) {
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
                      _formatDate(date),
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...events.map((event) => ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: event.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              event.icon,
                              color: event.color,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            event.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${event.startTime} - ${event.endTime}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showEventDetails(event);
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildEventTile(event),
        );
      },
    );
  }

  Widget _buildEventTile(EventItem event) {
    final now = DateTime.now();
    final isPast = event.startDate.isBefore(now);
    final isToday = _isSameDay(event.startDate, now);
    final daysUntil = event.startDate.difference(now).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday
              ? event.color.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: isToday ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Date indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getMonthAbbr(event.startDate.month),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: event.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      event.startDate.day.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: event.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isPast
                                  ? Colors.white38
                                  : Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (event.isRecurring)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.repeat,
                              size: 14,
                              color: Colors.blue.shade300,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.startTime} - ${event.endTime}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: isPast
                            ? Colors.white38
                            : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: isPast
                              ? Colors.white24
                              : Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: isPast
                                  ? Colors.white24
                                  : Colors.white60,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (!isPast && daysUntil > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: daysUntil <= 3
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          daysUntil == 1
                              ? 'Tomorrow'
                              : 'In $daysUntil days',
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            color: daysUntil <= 3
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Status indicator
              if (event.status == EventStatus.pending)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pending',
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

// Add Event Dialog
class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();
  final _attendeesController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  
  EventCategory _selectedCategory = EventCategory.family;
  bool _isRecurring = false;
  String _recurringPattern = 'Weekly';
  List<int> _selectedReminders = [1];
  
  final List<String> _recurringOptions = [
    'Daily', 'Weekly', 'Bi-weekly', 'Monthly', 'Quarterly', 'Yearly'
  ];

  final List<Map<String, dynamic>> _reminderOptions = [
    {'value': 0, 'label': 'At time of event'},
    {'value': 1, 'label': '1 day before'},
    {'value': 2, 'label': '2 days before'},
    {'value': 3, 'label': '3 days before'},
    {'value': 7, 'label': '1 week before'},
    {'value': 14, 'label': '2 weeks before'},
    {'value': 30, 'label': '1 month before'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _attendeesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
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
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: _startDate.add(const Duration(days: 30)),
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
        _endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
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
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
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
        _endTime = picked;
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
                    Icons.event,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Add New Event',
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
                      labelText: 'Event Title *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., Family Dinner',
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
                        return 'Please enter event title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date and Time
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Start Date
                        InkWell(
                          onTap: _selectStartDate,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.blue.shade300, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Date',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}',
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
                        const SizedBox(height: 12),
                        
                        // Start Time
                        InkWell(
                          onTap: _selectStartTime,
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.blue.shade300, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Time',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
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
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.white24, height: 1),
                        ),
                        
                        // End Date
                        InkWell(
                          onTap: _selectEndDate,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.orange.shade300, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Date',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      '${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')}',
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
                        const SizedBox(height: 12),
                        
                        // End Time
                        InkWell(
                          onTap: _selectEndTime,
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.orange.shade300, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Time',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Location *',
                      labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                      hintText: 'e.g., Home, School, Park',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade300),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<EventCategory>(
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
                    items: EventCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
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
                      hintText: 'Event description...',
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

                  // Attendees
                  TextFormField(
                    controller: _attendeesController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Attendees',
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

                  // Recurring
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Recurring Event',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isRecurring,
                              onChanged: (value) {
                                setState(() {
                                  _isRecurring = value;
                                });
                              },
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                        if (_isRecurring) ...[
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _recurringPattern,
                            dropdownColor: const Color(0xFF0B1E33),
                            style: GoogleFonts.montserrat(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Repeat',
                              labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                            ),
                            items: _recurringOptions.map((option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _recurringPattern = value!;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reminders
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reminders',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _reminderOptions.map((option) {
                            final isSelected = _selectedReminders.contains(option['value']);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(option['label']),
                              labelStyle: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                              backgroundColor: Colors.white.withOpacity(0.05),
                              selectedColor: Colors.blue,
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedReminders.add(option['value']);
                                  } else {
                                    _selectedReminders.remove(option['value']);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    maxLines: 2,
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
                          'startDate': _startDate,
                          'startTime': '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                          'endDate': _endDate,
                          'endTime': '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                          'location': _locationController.text,
                          'organizer': 'Current User',
                          'category': _selectedCategory,
                          'isRecurring': _isRecurring,
                          'recurringPattern': _isRecurring ? _recurringPattern : null,
                          'attendees': _attendeesController.text,
                          'reminders': _selectedReminders,
                          'notes': _notesController.text,
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
                    child: const Text('Create Event'),
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

// Edit Event Dialog
class EditEventDialog extends StatefulWidget {
  final EventItem event;

  const EditEventDialog({super.key, required this.event});

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _organizerController;
  late final TextEditingController _attendeesController;
  late final TextEditingController _notesController;
  
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  
  late EventCategory _selectedCategory;
  late bool _isRecurring;
  late String _recurringPattern;
  late List<int> _selectedReminders;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _organizerController = TextEditingController(text: widget.event.organizer);
    _attendeesController = TextEditingController(
      text: widget.event.attendees?.join(', ') ?? '',
    );
    _notesController = TextEditingController(text: widget.event.notes);
    
    _startDate = widget.event.startDate;
    _endDate = widget.event.endDate;
    
    final startParts = widget.event.startTime.split(':');
    _startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );
    
    final endParts = widget.event.endTime.split(':');
    _endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );
    
    _selectedCategory = widget.event.category;
    _isRecurring = widget.event.isRecurring;
    _recurringPattern = widget.event.recurringPattern ?? 'Weekly';
    _selectedReminders = List.from(widget.event.reminders);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _attendeesController.dispose();
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
                    'Edit Event',
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

            // Form (similar to add dialog with pre-filled values)
            Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Event Title *',
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

                // Date and Time display (simplified for edit)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue.shade300),
                        title: Text(
                          'Start: ${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')} ${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.orange.shade300),
                        title: Text(
                          'End: ${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')} ${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Location *',
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

                DropdownButtonFormField<EventCategory>(
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
                  items: EventCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
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
                  controller: _attendeesController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Attendees',
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

                // Recurring
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recurring Event',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Switch(
                            value: _isRecurring,
                            onChanged: (value) {
                              setState(() {
                                _isRecurring = value;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      if (_isRecurring) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _recurringPattern,
                          dropdownColor: const Color(0xFF0B1E33),
                          style: GoogleFonts.montserrat(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Repeat',
                            labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue.shade300),
                            ),
                          ),
                          items: const [
                            'Daily', 'Weekly', 'Bi-weekly', 'Monthly', 'Quarterly', 'Yearly'
                          ].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _recurringPattern = value!;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
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
                        'description': _descriptionController.text,
                        'startDate': _startDate,
                        'startTime': '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                        'endDate': _endDate,
                        'endTime': '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                        'location': _locationController.text,
                        'organizer': _organizerController.text,
                        'category': _selectedCategory,
                        'isRecurring': _isRecurring,
                        'recurringPattern': _isRecurring ? _recurringPattern : null,
                        'attendees': _attendeesController.text,
                        'reminders': _selectedReminders,
                        'notes': _notesController.text,
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
                    child: const Text('Update Event'),
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

enum EventCategory {
  birthday,
  family,
  holiday,
  vacation,
  medical,
  school,
  work,
  shopping,
  entertainment,
  important,
  other
}

enum EventStatus {
  confirmed,
  pending,
  cancelled
}

class EventItem {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String endTime;
  final String location;
  final String organizer;
  final EventCategory category;
  final Color color;
  final IconData icon;
  final bool isRecurring;
  final String? recurringPattern;
  final List<String>? attendees;
  final List<int> reminders;
  final List<String> attachments;
  final String? notes;
  final EventStatus status;
  final String createdBy;
  final DateTime createdAt;
  final String modifiedBy;
  final DateTime modifiedAt;

  EventItem({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.organizer,
    required this.category,
    required this.color,
    required this.icon,
    required this.isRecurring,
    this.recurringPattern,
    this.attendees,
    required this.reminders,
    required this.attachments,
    this.notes,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.modifiedBy,
    required this.modifiedAt,
  });
}