import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<DocumentItem> _allDocuments = [];
  List<DocumentItem> _filteredDocuments = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'PDF', 'Word', 'Excel', 'Recent'];

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
    
    // Load mock documents
    _loadDocuments();
    
    _searchController.addListener(_filterDocuments);
  }

  void _loadDocuments() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allDocuments.addAll([
          DocumentItem(
            name: 'Family Insurance Policy.pdf',
            type: 'PDF',
            size: '2.4 MB',
            modified: 'Today, 10:30 AM',
            modifiedBy: 'John Doe',
            icon: Icons.picture_as_pdf,
            color: Colors.red,
            description: 'Annual family insurance policy document',
            tags: ['insurance', 'important'],
          ),
          DocumentItem(
            name: 'Family Budget 2024.xlsx',
            type: 'Excel',
            size: '1.8 MB',
            modified: 'Yesterday, 3:45 PM',
            modifiedBy: 'Sarah Smith',
            icon: Icons.table_chart,
            color: Colors.green,
            description: 'Monthly family budget and expenses',
            tags: ['finance', 'budget'],
          ),
          DocumentItem(
            name: 'House Deed.docx',
            type: 'Word',
            size: '856 KB',
            modified: 'Dec 15, 2024',
            modifiedBy: 'Admin',
            icon: Icons.description,
            color: Colors.blue,
            description: 'Official house ownership document',
            tags: ['property', 'legal'],
          ),
          DocumentItem(
            name: 'Medical Records.pdf',
            type: 'PDF',
            size: '3.2 MB',
            modified: 'Dec 12, 2024',
            modifiedBy: 'Dr. Wilson',
            icon: Icons.picture_as_pdf,
            color: Colors.red,
            description: 'Family medical history and records',
            tags: ['health', 'medical'],
          ),
          DocumentItem(
            name: 'Kids School Records.xlsx',
            type: 'Excel',
            size: '1.2 MB',
            modified: 'Dec 10, 2024',
            modifiedBy: 'Mary Johnson',
            icon: Icons.table_chart,
            color: Colors.green,
            description: 'School grades and attendance records',
            tags: ['education', 'school'],
          ),
          DocumentItem(
            name: 'Travel Itinerary.docx',
            type: 'Word',
            size: '654 KB',
            modified: 'Dec 8, 2024',
            modifiedBy: 'Travel Agent',
            icon: Icons.description,
            color: Colors.blue,
            description: 'Family vacation plans and bookings',
            tags: ['travel', 'vacation'],
          ),
          DocumentItem(
            name: 'Tax Returns 2023.pdf',
            type: 'PDF',
            size: '4.1 MB',
            modified: 'Dec 5, 2024',
            modifiedBy: 'Accountant',
            icon: Icons.picture_as_pdf,
            color: Colors.red,
            description: 'Annual tax filing documents',
            tags: ['tax', 'finance'],
          ),
          DocumentItem(
            name: 'Investment Portfolio.xlsx',
            type: 'Excel',
            size: '2.6 MB',
            modified: 'Dec 3, 2024',
            modifiedBy: 'Financial Advisor',
            icon: Icons.table_chart,
            color: Colors.green,
            description: 'Family investments and stocks',
            tags: ['investment', 'finance'],
          ),
          DocumentItem(
            name: 'Legal Agreement.docx',
            type: 'Word',
            size: '1.1 MB',
            modified: 'Nov 28, 2024',
            modifiedBy: 'Lawyer',
            icon: Icons.description,
            color: Colors.blue,
            description: 'Legal agreement document',
            tags: ['legal', 'contract'],
          ),
        ]);
        
        _filteredDocuments = _allDocuments;
        _isLoading = false;
      });
    });
  }

  void _filterDocuments() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDocuments = _allDocuments.where((doc) {
        return doc.name.toLowerCase().contains(query) ||
               doc.type.toLowerCase().contains(query) ||
               doc.modifiedBy.toLowerCase().contains(query) ||
               (doc.description?.toLowerCase().contains(query) ?? false) ||
               (doc.tags?.any((tag) => tag.toLowerCase().contains(query)) ?? false);
      }).toList();
      
      // Apply type filter
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Recent') {
          // Show documents modified in the last 7 days
          _filteredDocuments = _filteredDocuments.where((doc) {
            return doc.modified.toLowerCase().contains('today') ||
                   doc.modified.toLowerCase().contains('yesterday');
          }).toList();
        } else {
          _filteredDocuments = _filteredDocuments.where((doc) {
            return doc.type == _selectedFilter;
          }).toList();
        }
      }
    });
  }

  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FileUploadBottomSheet(),
    ).then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        _addUploadedFiles(value);
      }
    });
  }

  void _addUploadedFiles(List<Map<String, dynamic>> uploadedFiles) {
    setState(() {
      for (var file in uploadedFiles) {
        final newDoc = DocumentItem(
          name: file['fileName'],
          type: file['fileType'],
          size: file['fileSize'],
          modified: 'Just now',
          modifiedBy: 'Current User', // Replace with actual user
          icon: _getIconForType(file['fileType']),
          color: _getColorForType(file['fileType']),
          description: file['description'],
          tags: file['tags'] != null 
              ? (file['tags'] as String).split(',').map((e) => e.trim()).toList()
              : [],
        );
        _allDocuments.insert(0, newDoc);
      }
      _filterDocuments();
    });

    _showSnackBar(
      '${uploadedFiles.length} file(s) uploaded successfully',
      isError: false,
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Word':
        return Icons.description;
      case 'Excel':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'Word':
        return Colors.blue;
      case 'Excel':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showShareOptions(DocumentItem document) {
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: document.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        document.icon,
                        color: document.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      document.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${document.size} • ${document.modified}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    if (document.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        document.description!,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    
                    // Share Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareOption(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {
                            Navigator.pop(context);
                            _showShareSuccess(document.name);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.download,
                          label: 'Download',
                          onTap: () {
                            Navigator.pop(context);
                            _showDownloadSuccess(document.name);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.copy,
                          label: 'Copy Link',
                          onTap: () {
                            Navigator.pop(context);
                            _showCopySuccess();
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.info_outline,
                          label: 'Details',
                          onTap: () {
                            Navigator.pop(context);
                            _showDocumentDetails(document);
                          },
                        ),
                      ],
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

  void _showDocumentDetails(DocumentItem document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: document.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      document.icon,
                      color: document.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Details',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildDetailRow('File Name:', document.name),
              _buildDetailRow('Type:', document.type),
              _buildDetailRow('Size:', document.size),
              _buildDetailRow('Modified:', document.modified),
              _buildDetailRow('Modified By:', document.modifiedBy),
              if (document.description != null)
                _buildDetailRow('Description:', document.description!),
              if (document.tags != null && document.tags!.isNotEmpty)
                _buildDetailRow('Tags:', document.tags!.join(', ')),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: GoogleFonts.montserrat(
                        color: Colors.blue.shade300,
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareSuccess(String fileName) {
    _showSnackBar('Sharing options for "$fileName"', isError: false);
  }

  void _showDownloadSuccess(String fileName) {
    _showSnackBar('Downloading "$fileName"', isError: false);
  }

  void _showCopySuccess() {
    _showSnackBar('Link copied to clipboard', isError: false);
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
                            'Documents',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredDocuments.length} files • Family shared',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Upload button
                    GestureDetector(
                      onTap: _showUploadDialog,
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
                          Icons.cloud_upload,
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
                          hintText: 'Search documents...',
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
                                  _filterDocuments();
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

              // Documents list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredDocuments.isEmpty
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
                                  'No documents found',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _showUploadDialog,
                                  icon: const Icon(Icons.cloud_upload),
                                  label: const Text('Upload Files'),
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
                            itemCount: _filteredDocuments.length,
                            itemBuilder: (context, index) {
                              final doc = _filteredDocuments[index];
                              return FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildDocumentTile(doc),
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

  Widget _buildDocumentTile(DocumentItem document) {
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
        onTap: () {
          // Open document preview
          _showDocumentPreview(document);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // File icon with preview
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: document.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        document.icon,
                        color: document.color,
                        size: 30,
                      ),
                    ),
                    if (document.type == 'PDF')
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade900,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PDF',
                            style: GoogleFonts.montserrat(
                              fontSize: 6,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // File details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (document.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        document.description!,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: Colors.white60,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          document.modifiedBy,
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
                        Icon(
                          Icons.access_time,
                          size: 11,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          document.modified,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ),
                      ],
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
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            document.size,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        if (document.tags != null && document.tags!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: document.tags!.take(2).map((tag) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 8,
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                );
                              }).toList(),
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
                  _buildActionButton(
                    icon: Icons.share,
                    color: Colors.blue,
                    onTap: () => _showShareOptions(document),
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Icons.download,
                    color: Colors.green,
                    onTap: () => _showDownloadSuccess(document.name),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showDocumentPreview(DocumentItem document) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
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
                  children: [
                    // Preview header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: document.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            document.icon,
                            color: document.color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Modified ${document.modified} • ${document.size}',
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
                    
                    const SizedBox(height: 24),
                    
                    // Preview content (placeholder)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              document.icon,
                              size: 60,
                              color: document.color.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Preview not available',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to open with external app',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildPreviewActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            color: Colors.blue,
                            onTap: () {
                              Navigator.pop(context);
                              _showShareOptions(document);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPreviewActionButton(
                            icon: Icons.download,
                            label: 'Download',
                            color: Colors.green,
                            onTap: () {
                              Navigator.pop(context);
                              _showDownloadSuccess(document.name);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPreviewActionButton(
                            icon: Icons.open_in_new,
                            label: 'Open',
                            color: Colors.orange,
                            onTap: () {
                              Navigator.pop(context);
                              // Open with external app logic
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
    );
  }

  Widget _buildPreviewActionButton({
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
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// File Upload Bottom Sheet
class FileUploadBottomSheet extends StatefulWidget {
  const FileUploadBottomSheet({super.key});

  @override
  State<FileUploadBottomSheet> createState() => _FileUploadBottomSheetState();
}

class _FileUploadBottomSheetState extends State<FileUploadBottomSheet> {
  final List<FileUploadItem> _files = [];
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the current file being added
  final _fileNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String _selectedFileType = 'PDF';
  final List<String> _fileTypes = ['PDF', 'Word', 'Excel', 'Other'];
  
  bool _isAddingFile = false;

  @override
  void dispose() {
    _fileNameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addFileToList() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _files.add(FileUploadItem(
          fileName: _fileNameController.text,
          fileType: _selectedFileType,
          description: _descriptionController.text,
          tags: _tagsController.text,
          fileSize: _generateRandomSize(),
        ));
        
        // Clear controllers for next file
        _fileNameController.clear();
        _descriptionController.clear();
        _tagsController.clear();
        _selectedFileType = 'PDF';
        _isAddingFile = false;
      });
    }
  }

  String _generateRandomSize() {
    final sizes = ['1.2 MB', '2.5 MB', '856 KB', '3.1 MB', '4.7 MB', '654 KB'];
    return sizes[_files.length % sizes.length];
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _submitFiles() {
    if (_files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Return the list of files
    Navigator.pop(context, _files.map((file) => file.toMap()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Upload Documents',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Files list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // List of added files
                    if (_files.isNotEmpty) ...[
                      ...List.generate(_files.length, (index) {
                        final file = _files[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getColorForType(file.fileType).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getIconForType(file.fileType),
                                  color: _getColorForType(file.fileType),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file.fileName,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${file.fileType} • ${file.fileSize}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    if (file.description.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          file.description,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            color: Colors.white60,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeFile(index),
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade300,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                    
                    // Add new file form
                    if (_isAddingFile)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // File Name
                              TextFormField(
                                controller: _fileNameController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'File Name',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Family Budget 2024',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.insert_drive_file, color: Colors.blue.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade300),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter file name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // File Type Dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedFileType,
                                dropdownColor: const Color(0xFF0B1E33),
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'File Type',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  prefixIcon: Icon(Icons.category, color: Colors.blue.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade300),
                                  ),
                                ),
                                items: _fileTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFileType = value!;
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
                                  labelText: 'Description (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'Brief description of the document',
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
                                  labelText: 'Tags (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., finance, important, legal',
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
                              const SizedBox(height: 20),
                              
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isAddingFile = false;
                                        });
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.montserrat(color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _addFileToList,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade800,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Add Document'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isAddingFile)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isAddingFile = true;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                  'Add Another Document',
                                  style: GoogleFonts.montserrat(),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue.shade300,
                                  side: BorderSide(color: Colors.blue.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Row(
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
                      onPressed: _submitFiles,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Upload ${_files.length} Document${_files.length != 1 ? 's' : ''}',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Word':
        return Icons.description;
      case 'Excel':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'Word':
        return Colors.blue;
      case 'Excel':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class FileUploadItem {
  final String fileName;
  final String fileType;
  final String description;
  final String tags;
  final String fileSize;

  FileUploadItem({
    required this.fileName,
    required this.fileType,
    required this.description,
    required this.tags,
    required this.fileSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileType': fileType,
      'description': description,
      'tags': tags,
      'fileSize': fileSize,
    };
  }
}

class DocumentItem {
  final String name;
  final String type;
  final String size;
  final String modified;
  final String modifiedBy;
  final IconData icon;
  final Color color;
  final String? description;
  final List<String>? tags;
  final String? previewUrl;

  DocumentItem({
    required this.name,
    required this.type,
    required this.size,
    required this.modified,
    required this.modifiedBy,
    required this.icon,
    required this.color,
    this.description,
    this.tags,
    this.previewUrl,
  });
}