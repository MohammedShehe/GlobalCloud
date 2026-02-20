import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<PhotoItem> _allPhotos = [];
  List<PhotoItem> _filteredPhotos = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Albums', 'Favorites', 'Recent', 'Shared'];
  
  // View mode: grid or list
  bool _isGridView = true;

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
    
    // Load mock photos
    _loadPhotos();
    
    _searchController.addListener(_filterPhotos);
  }

  void _loadPhotos() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allPhotos.addAll([
          PhotoItem(
            name: 'Family Vacation 2024',
            fileName: 'IMG_001.jpg',
            size: '3.2 MB',
            resolution: '4032 x 3024',
            modified: 'Today, 10:30 AM',
            modifiedBy: 'John Doe',
            color: Colors.blue,
            thumbnailUrl: null, // Would be actual image URL
            album: 'Vacation',
            isFavorite: true,
            location: 'Beach Resort',
            people: ['John', 'Sarah', 'Kids'],
          ),
          PhotoItem(
            name: 'Birthday Party',
            fileName: 'IMG_002.jpg',
            size: '2.8 MB',
            resolution: '3024 x 4032',
            modified: 'Yesterday, 3:45 PM',
            modifiedBy: 'Sarah Smith',
            color: Colors.purple,
            thumbnailUrl: null,
            album: 'Celebrations',
            isFavorite: false,
            location: 'Home',
            people: ['Sarah', 'Mike', 'Emma'],
          ),
          PhotoItem(
            name: 'Christmas Morning',
            fileName: 'IMG_003.jpg',
            size: '4.1 MB',
            resolution: '4032 x 3024',
            modified: 'Dec 25, 2024',
            modifiedBy: 'Admin',
            color: Colors.red,
            thumbnailUrl: null,
            album: 'Holidays',
            isFavorite: true,
            location: 'Living Room',
            people: ['Family'],
          ),
          PhotoItem(
            name: 'Hiking Adventure',
            fileName: 'IMG_004.jpg',
            size: '5.3 MB',
            resolution: '4032 x 3024',
            modified: 'Dec 20, 2024',
            modifiedBy: 'Mike Johnson',
            color: Colors.green,
            thumbnailUrl: null,
            album: 'Outdoor',
            isFavorite: false,
            location: 'Mountain Trail',
            people: ['Mike', 'Friends'],
          ),
          PhotoItem(
            name: 'School Play',
            fileName: 'IMG_005.jpg',
            size: '2.2 MB',
            resolution: '3024 x 4032',
            modified: 'Dec 15, 2024',
            modifiedBy: 'Emma Watson',
            color: Colors.orange,
            thumbnailUrl: null,
            album: 'School',
            isFavorite: true,
            location: 'School Auditorium',
            people: ['Emma', 'Classmates'],
          ),
          PhotoItem(
            name: 'Thanksgiving Dinner',
            fileName: 'IMG_006.jpg',
            size: '3.7 MB',
            resolution: '4032 x 3024',
            modified: 'Nov 28, 2024',
            modifiedBy: 'Grandma',
            color: Colors.amber,
            thumbnailUrl: null,
            album: 'Family Gatherings',
            isFavorite: false,
            location: 'Grandma\'s House',
            people: ['Extended Family'],
          ),
          PhotoItem(
            name: 'Baby\'s First Steps',
            fileName: 'IMG_007.jpg',
            size: '4.5 MB',
            resolution: '4032 x 3024',
            modified: 'Nov 20, 2024',
            modifiedBy: 'Mom',
            color: Colors.pink,
            thumbnailUrl: null,
            album: 'Milestones',
            isFavorite: true,
            location: 'Home',
            people: ['Baby', 'Mom', 'Dad'],
          ),
          PhotoItem(
            name: 'Graduation Day',
            fileName: 'IMG_008.jpg',
            size: '6.1 MB',
            resolution: '4032 x 3024',
            modified: 'Nov 10, 2024',
            modifiedBy: 'Dad',
            color: Colors.teal,
            thumbnailUrl: null,
            album: 'Achievements',
            isFavorite: true,
            location: 'University',
            people: ['Graduate', 'Family'],
          ),
        ]);
        
        _filteredPhotos = _allPhotos;
        _isLoading = false;
      });
    });
  }

  void _filterPhotos() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPhotos = _allPhotos.where((photo) {
        return photo.name.toLowerCase().contains(query) ||
               photo.fileName.toLowerCase().contains(query) ||
               photo.modifiedBy.toLowerCase().contains(query) ||
               (photo.album?.toLowerCase().contains(query) ?? false) ||
               (photo.location?.toLowerCase().contains(query) ?? false) ||
               (photo.people?.any((person) => person.toLowerCase().contains(query)) ?? false);
      }).toList();
      
      // Apply filters
      switch (_selectedFilter) {
        case 'Favorites':
          _filteredPhotos = _filteredPhotos.where((photo) => photo.isFavorite).toList();
          break;
        case 'Recent':
          // Show photos modified in the last 7 days
          _filteredPhotos = _filteredPhotos.where((photo) {
            return photo.modified.toLowerCase().contains('today') ||
                   photo.modified.toLowerCase().contains('yesterday');
          }).toList();
          break;
        case 'Albums':
          // Group by album - handled in UI
          break;
        case 'Shared':
          // Photos shared with family
          _filteredPhotos = _filteredPhotos.where((photo) => 
            photo.people != null && photo.people!.length > 1).toList();
          break;
        default:
          // 'All' - no additional filter
          break;
      }
    });
  }

  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PhotoUploadBottomSheet(),
    ).then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        _addUploadedPhotos(value);
      }
    });
  }

  void _addUploadedPhotos(List<Map<String, dynamic>> uploadedPhotos) {
    setState(() {
      for (var photo in uploadedPhotos) {
        final newPhoto = PhotoItem(
          name: photo['photoName'],
          fileName: photo['fileName'] ?? 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
          size: photo['fileSize'] ?? '2.5 MB',
          resolution: '4032 x 3024',
          modified: 'Just now',
          modifiedBy: 'Current User', // Replace with actual user
          color: _getRandomColor(),
          thumbnailUrl: null,
          album: photo['album'],
          isFavorite: false,
          location: photo['location'],
          people: photo['people'] != null 
              ? (photo['people'] as String).split(',').map((e) => e.trim()).toList()
              : [],
        );
        _allPhotos.insert(0, newPhoto);
      }
      _filterPhotos();
    });

    _showSnackBar(
      '${uploadedPhotos.length} photo(s) uploaded successfully',
      isError: false,
    );
  }

  Color _getRandomColor() {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    return colors[_allPhotos.length % colors.length];
  }

  void _showPhotoOptions(PhotoItem photo) {
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
                    // Photo preview
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: photo.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        image: photo.thumbnailUrl != null
                            ? DecorationImage(
                                image: NetworkImage(photo.thumbnailUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: photo.thumbnailUrl == null
                          ? Center(
                              child: Icon(
                                Icons.photo,
                                size: 50,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      photo.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${photo.fileName} • ${photo.size}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPhotoActionButton(
                          icon: Icons.favorite_border,
                          selectedIcon: Icons.favorite,
                          isSelected: photo.isFavorite,
                          label: 'Favorite',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              photo.isFavorite = !photo.isFavorite;
                            });
                            _showSnackBar(
                              photo.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                              isError: false,
                            );
                          },
                        ),
                        _buildPhotoActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _showShareOptions(photo);
                          },
                        ),
                        _buildPhotoActionButton(
                          icon: Icons.download,
                          label: 'Download',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showDownloadSuccess(photo.name);
                          },
                        ),
                        _buildPhotoActionButton(
                          icon: Icons.info_outline,
                          label: 'Details',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            _showPhotoDetails(photo);
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

  Widget _buildPhotoActionButton({
    required IconData icon,
    IconData? selectedIcon,
    bool isSelected = false,
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
              isSelected ? (selectedIcon ?? icon) : icon,
              color: isSelected ? color : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: isSelected ? color : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(PhotoItem photo) {
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
                      'Share "${photo.name}"',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Share options grid
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
                          icon: Icons.link,
                          label: 'Copy Link',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showCopySuccess();
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.chat, // Changed from Icons.whatsapp
                          label: 'Chat',
                          color: Colors.green.shade700,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening chat...', isError: false);
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
                          icon: Icons.facebook, // This also doesn't exist, so let's change this too
                          label: 'Facebook',
                          color: Colors.blue.shade800,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening Facebook...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.message,
                          label: 'Messages',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Opening messages...', isError: false);
                          },
                        ),
                        _buildShareOption(
                          icon: Icons.cloud,
                          label: 'Cloud',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            _showSnackBar('Uploading to cloud...', isError: false);
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

  void _showPhotoDetails(PhotoItem photo) {
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
                      color: photo.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo,
                      color: photo.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photo Details',
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
              
              _buildDetailRow('Name:', photo.name),
              _buildDetailRow('File Name:', photo.fileName),
              _buildDetailRow('Size:', photo.size),
              _buildDetailRow('Resolution:', photo.resolution),
              _buildDetailRow('Modified:', photo.modified),
              _buildDetailRow('Modified By:', photo.modifiedBy),
              if (photo.album != null)
                _buildDetailRow('Album:', photo.album!),
              if (photo.location != null)
                _buildDetailRow('Location:', photo.location!),
              if (photo.people != null && photo.people!.isNotEmpty)
                _buildDetailRow('People:', photo.people!.join(', ')),
              _buildDetailRow('Favorite:', photo.isFavorite ? 'Yes' : 'No'),
              
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
            width: 90,
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

  void _showDownloadSuccess(String photoName) {
    _showSnackBar('Downloading "$photoName"', isError: false);
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

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
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
                            'Photos',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredPhotos.length} photos • Family album',
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
                      onPressed: _toggleViewMode,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isGridView ? Icons.view_list : Icons.grid_view,
                          size: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          hintText: 'Search photos...',
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
                                  _filterPhotos();
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

              // Photos grid/list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredPhotos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 80,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No photos found',
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
                                  label: const Text('Upload Photos'),
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
                        : _isGridView
                            ? _buildGridView()
                            : _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: _filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = _filteredPhotos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => _showPhotoOptions(photo),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    photo.color.withOpacity(0.3),
                    photo.color.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Stack(
                children: [
                  // Thumbnail placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 30,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          photo.fileName.length > 10
                              ? '...${photo.fileName.substring(photo.fileName.length - 10)}'
                              : photo.fileName,
                          style: GoogleFonts.montserrat(
                            fontSize: 8,
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorite indicator
                  if (photo.isFavorite)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = _filteredPhotos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildPhotoTile(photo),
        );
      },
    );
  }

  Widget _buildPhotoTile(PhotoItem photo) {
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
        onTap: () => _showPhotoOptions(photo),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Photo thumbnail
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: photo.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.photo,
                    color: Colors.white.withOpacity(0.5),
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Photo details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      photo.fileName,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                          photo.modifiedBy,
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
                          photo.modified,
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
                            photo.size,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        if (photo.resolution.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                photo.resolution,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.blue.shade200,
                                ),
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
                  _buildActionButton(
                    icon: photo.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onTap: () {
                      setState(() {
                        photo.isFavorite = !photo.isFavorite;
                      });
                      _showSnackBar(
                        photo.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                        isError: false,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Icons.share,
                    color: Colors.blue,
                    onTap: () => _showShareOptions(photo),
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
}

// Photo Upload Bottom Sheet
class PhotoUploadBottomSheet extends StatefulWidget {
  const PhotoUploadBottomSheet({super.key});

  @override
  State<PhotoUploadBottomSheet> createState() => _PhotoUploadBottomSheetState();
}

class _PhotoUploadBottomSheetState extends State<PhotoUploadBottomSheet> {
  final List<PhotoUploadItem> _photos = [];
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the current photo being added
  final _photoNameController = TextEditingController();
  final _fileNameController = TextEditingController();
  final _albumController = TextEditingController();
  final _locationController = TextEditingController();
  final _peopleController = TextEditingController();
  
  bool _isAddingPhoto = false;

  @override
  void dispose() {
    _photoNameController.dispose();
    _fileNameController.dispose();
    _albumController.dispose();
    _locationController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _addPhotoToList() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _photos.add(PhotoUploadItem(
          photoName: _photoNameController.text,
          fileName: _fileNameController.text,
          album: _albumController.text,
          location: _locationController.text,
          people: _peopleController.text,
          fileSize: _generateRandomSize(),
        ));
        
        // Clear controllers for next photo
        _photoNameController.clear();
        _fileNameController.clear();
        _albumController.clear();
        _locationController.clear();
        _peopleController.clear();
        _isAddingPhoto = false;
      });
    }
  }

  String _generateRandomSize() {
    final sizes = ['2.5 MB', '3.8 MB', '1.2 MB', '4.5 MB', '5.1 MB', '2.2 MB'];
    return sizes[_photos.length % sizes.length];
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _submitPhotos() {
    if (_photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Return the list of photos
    Navigator.pop(context, _photos.map((photo) => photo.toMap()).toList());
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
                    'Upload Photos',
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
            
            // Photos list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // List of added photos
                    if (_photos.isNotEmpty) ...[
                      ...List.generate(_photos.length, (index) {
                        final photo = _photos[index];
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
                                  color: Colors.blue.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.photo,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      photo.photoName,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${photo.fileName} • ${photo.fileSize}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    if (photo.album.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          'Album: ${photo.album}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            color: Colors.blue.shade200,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removePhoto(index),
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
                    
                    // Add new photo form
                    if (_isAddingPhoto)
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
                              // Photo Name
                              TextFormField(
                                controller: _photoNameController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Photo Name',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Family Vacation 2024',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.photo, color: Colors.blue.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade300),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter photo name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // File Name
                              TextFormField(
                                controller: _fileNameController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'File Name',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., IMG_001.jpg',
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
                              
                              // Album
                              TextFormField(
                                controller: _albumController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Album (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Vacation, Birthday',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.photo_album, color: Colors.blue.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade300),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Location
                              TextFormField(
                                controller: _locationController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Location (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Beach, Home',
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
                              
                              // People
                              TextFormField(
                                controller: _peopleController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'People (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., John, Sarah, comma separated',
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
                              const SizedBox(height: 20),
                              
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isAddingPhoto = false;
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
                                      onPressed: _addPhotoToList,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade800,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Add Photo'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isAddingPhoto)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isAddingPhoto = true;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                  'Add Another Photo',
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
                      onPressed: _submitPhotos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Upload ${_photos.length} Photo${_photos.length != 1 ? 's' : ''}',
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
}

class PhotoUploadItem {
  final String photoName;
  final String fileName;
  final String album;
  final String location;
  final String people;
  final String fileSize;

  PhotoUploadItem({
    required this.photoName,
    required this.fileName,
    required this.album,
    required this.location,
    required this.people,
    required this.fileSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'photoName': photoName,
      'fileName': fileName,
      'album': album,
      'location': location,
      'people': people,
      'fileSize': fileSize,
    };
  }
}

class PhotoItem {
  final String name;
  final String fileName;
  final String size;
  final String resolution;
  final String modified;
  final String modifiedBy;
  final Color color;
  final String? thumbnailUrl;
  final String? album;
  bool isFavorite;
  final String? location;
  final List<String>? people;

  PhotoItem({
    required this.name,
    required this.fileName,
    required this.size,
    required this.resolution,
    required this.modified,
    required this.modifiedBy,
    required this.color,
    this.thumbnailUrl,
    this.album,
    this.isFavorite = false,
    this.location,
    this.people,
  });
}