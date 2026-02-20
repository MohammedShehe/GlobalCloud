import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final List<VideoItem> _allVideos = [];
  List<VideoItem> _filteredVideos = [];
  
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Favorites', 'Recent', 'Movies', 'Family', 'Shared'];
  
  // View mode: grid or list
  bool _isGridView = false; // Default to list view for videos

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
    
    // Load mock videos
    _loadVideos();
    
    _searchController.addListener(_filterVideos);
  }

  void _loadVideos() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allVideos.addAll([
          VideoItem(
            name: 'Family Vacation Compilation',
            fileName: 'vacation_2024.mp4',
            size: '156 MB',
            duration: '5:32',
            resolution: '1080p',
            modified: 'Today, 2:30 PM',
            modifiedBy: 'John Doe',
            color: Colors.red,
            thumbnailUrl: null,
            folder: 'Vacation',
            isFavorite: true,
            location: 'Beach Resort',
            people: ['John', 'Sarah', 'Kids'],
            views: 24,
          ),
          VideoItem(
            name: 'Birthday Party Highlights',
            fileName: 'birthday_sarah.mp4',
            size: '98 MB',
            duration: '3:45',
            resolution: '720p',
            modified: 'Yesterday, 6:15 PM',
            modifiedBy: 'Sarah Smith',
            color: Colors.purple,
            thumbnailUrl: null,
            folder: 'Celebrations',
            isFavorite: false,
            location: 'Home',
            people: ['Sarah', 'Mike', 'Emma'],
            views: 15,
          ),
          VideoItem(
            name: 'Christmas Morning 2024',
            fileName: 'xmas_2024.mp4',
            size: '210 MB',
            duration: '8:20',
            resolution: '4K',
            modified: 'Dec 25, 2024',
            modifiedBy: 'Admin',
            color: Colors.green,
            thumbnailUrl: null,
            folder: 'Holidays',
            isFavorite: true,
            location: 'Living Room',
            people: ['Family'],
            views: 42,
          ),
          VideoItem(
            name: 'Hiking Adventure Vlog',
            fileName: 'hiking_trail.mp4',
            size: '320 MB',
            duration: '12:15',
            resolution: '1080p',
            modified: 'Dec 20, 2024',
            modifiedBy: 'Mike Johnson',
            color: Colors.orange,
            thumbnailUrl: null,
            folder: 'Outdoor',
            isFavorite: false,
            location: 'Mountain Trail',
            people: ['Mike', 'Friends'],
            views: 18,
          ),
          VideoItem(
            name: 'School Play Performance',
            fileName: 'school_play.mp4',
            size: '185 MB',
            duration: '7:48',
            resolution: '720p',
            modified: 'Dec 15, 2024',
            modifiedBy: 'Emma Watson',
            color: Colors.blue,
            thumbnailUrl: null,
            folder: 'School',
            isFavorite: true,
            location: 'School Auditorium',
            people: ['Emma', 'Classmates'],
            views: 31,
          ),
          VideoItem(
            name: 'Thanksgiving Dinner',
            fileName: 'thanksgiving.mp4',
            size: '145 MB',
            duration: '6:22',
            resolution: '1080p',
            modified: 'Nov 28, 2024',
            modifiedBy: 'Grandma',
            color: Colors.amber,
            thumbnailUrl: null,
            folder: 'Family Gatherings',
            isFavorite: false,
            location: 'Grandma\'s House',
            people: ['Extended Family'],
            views: 27,
          ),
          VideoItem(
            name: 'Baby\'s First Steps',
            fileName: 'first_steps.mp4',
            size: '89 MB',
            duration: '2:15',
            resolution: '4K',
            modified: 'Nov 20, 2024',
            modifiedBy: 'Mom',
            color: Colors.pink,
            thumbnailUrl: null,
            folder: 'Milestones',
            isFavorite: true,
            location: 'Home',
            people: ['Baby', 'Mom', 'Dad'],
            views: 56,
          ),
          VideoItem(
            name: 'Graduation Ceremony',
            fileName: 'graduation.mp4',
            size: '420 MB',
            duration: '18:30',
            resolution: '1080p',
            modified: 'Nov 10, 2024',
            modifiedBy: 'Dad',
            color: Colors.teal,
            thumbnailUrl: null,
            folder: 'Achievements',
            isFavorite: true,
            location: 'University',
            people: ['Graduate', 'Family'],
            views: 33,
          ),
          VideoItem(
            name: 'Summer BBQ Party',
            fileName: 'bbq_summer.mp4',
            size: '167 MB',
            duration: '4:55',
            resolution: '1080p',
            modified: 'Aug 15, 2024',
            modifiedBy: 'Uncle Bob',
            color: Colors.brown,
            thumbnailUrl: null,
            folder: 'Parties',
            isFavorite: false,
            location: 'Backyard',
            people: ['Family', 'Friends'],
            views: 21,
          ),
        ]);
        
        _filteredVideos = _allVideos;
        _isLoading = false;
      });
    });
  }

  void _filterVideos() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVideos = _allVideos.where((video) {
        return video.name.toLowerCase().contains(query) ||
               video.fileName.toLowerCase().contains(query) ||
               video.modifiedBy.toLowerCase().contains(query) ||
               (video.folder?.toLowerCase().contains(query) ?? false) ||
               (video.location?.toLowerCase().contains(query) ?? false) ||
               (video.people?.any((person) => person.toLowerCase().contains(query)) ?? false);
      }).toList();
      
      // Apply filters
      switch (_selectedFilter) {
        case 'Favorites':
          _filteredVideos = _filteredVideos.where((video) => video.isFavorite).toList();
          break;
        case 'Recent':
          // Show videos modified in the last 7 days
          _filteredVideos = _filteredVideos.where((video) {
            return video.modified.toLowerCase().contains('today') ||
                   video.modified.toLowerCase().contains('yesterday');
          }).toList();
          break;
        case 'Movies':
          // Videos longer than 10 minutes
          _filteredVideos = _filteredVideos.where((video) {
            final minutes = int.tryParse(video.duration.split(':')[0]) ?? 0;
            return minutes >= 10;
          }).toList();
          break;
        case 'Family':
          // Videos tagged with family
          _filteredVideos = _filteredVideos.where((video) => 
            video.folder == 'Family Gatherings' || 
            video.folder == 'Milestones' ||
            (video.people?.contains('Family') ?? false)).toList();
          break;
        case 'Shared':
          // Videos with many views
          _filteredVideos = _filteredVideos.where((video) => video.views > 20).toList();
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
      builder: (context) => const VideoUploadBottomSheet(),
    ).then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        _addUploadedVideos(value);
      }
    });
  }

  void _addUploadedVideos(List<Map<String, dynamic>> uploadedVideos) {
    setState(() {
      for (var video in uploadedVideos) {
        final newVideo = VideoItem(
          name: video['videoName'],
          fileName: video['fileName'] ?? 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
          size: video['fileSize'] ?? '120 MB',
          duration: video['duration'] ?? '3:30',
          resolution: video['resolution'] ?? '1080p',
          modified: 'Just now',
          modifiedBy: 'Current User', // Replace with actual user
          color: _getRandomColor(),
          thumbnailUrl: null,
          folder: video['folder'],
          isFavorite: false,
          location: video['location'],
          people: video['people'] != null 
              ? (video['people'] as String).split(',').map((e) => e.trim()).toList()
              : [],
          views: 0,
        );
        _allVideos.insert(0, newVideo);
      }
      _filterVideos();
    });

    _showSnackBar(
      '${uploadedVideos.length} video(s) uploaded successfully',
      isError: false,
    );
  }

  Color _getRandomColor() {
    final colors = [Colors.red, Colors.purple, Colors.blue, Colors.green, Colors.orange, Colors.teal];
    return colors[_allVideos.length % colors.length];
  }

  void _showVideoOptions(VideoItem video) {
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
                    // Video preview thumbnail
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: video.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        image: video.thumbnailUrl != null
                            ? DecorationImage(
                                image: NetworkImage(video.thumbnailUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: video.thumbnailUrl == null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.video_library,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      video.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${video.fileName} • ${video.size} • ${video.duration}',
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
                        _buildVideoActionButton(
                          icon: Icons.favorite_border,
                          selectedIcon: Icons.favorite,
                          isSelected: video.isFavorite,
                          label: 'Favorite',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              video.isFavorite = !video.isFavorite;
                            });
                            _showSnackBar(
                              video.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                              isError: false,
                            );
                          },
                        ),
                        _buildVideoActionButton(
                          icon: Icons.play_circle_outline,
                          label: 'Play',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _showVideoPlayer(video);
                          },
                        ),
                        _buildVideoActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _showShareOptions(video);
                          },
                        ),
                        _buildVideoActionButton(
                          icon: Icons.download,
                          label: 'Download',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            _showDownloadSuccess(video.name);
                          },
                        ),
                        _buildVideoActionButton(
                          icon: Icons.info_outline,
                          label: 'Details',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pop(context);
                            _showVideoDetails(video);
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

  Widget _buildVideoActionButton({
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? (selectedIcon ?? icon) : icon,
              color: isSelected ? color : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: isSelected ? color : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoPlayer(VideoItem video) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              // Video player placeholder
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: video.color.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Playing: ${video.name}',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${video.duration} • ${video.resolution}',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Video player demo -在实际 app 中，这里会播放视频',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareOptions(VideoItem video) {
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
                      'Share "${video.name}"',
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
                          icon: Icons.chat,
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
                          icon: Icons.download,
                          label: 'Save',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _showDownloadSuccess(video.name);
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

  void _showVideoDetails(VideoItem video) {
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
                      color: video.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.video_library,
                      color: video.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video Details',
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
              
              _buildDetailRow('Name:', video.name),
              _buildDetailRow('File Name:', video.fileName),
              _buildDetailRow('Size:', video.size),
              _buildDetailRow('Duration:', video.duration),
              _buildDetailRow('Resolution:', video.resolution),
              _buildDetailRow('Modified:', video.modified),
              _buildDetailRow('Modified By:', video.modifiedBy),
              _buildDetailRow('Views:', '${video.views}'),
              if (video.folder != null)
                _buildDetailRow('Folder:', video.folder!),
              if (video.location != null)
                _buildDetailRow('Location:', video.location!),
              if (video.people != null && video.people!.isNotEmpty)
                _buildDetailRow('People:', video.people!.join(', ')),
              _buildDetailRow('Favorite:', video.isFavorite ? 'Yes' : 'No'),
              
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
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showVideoPlayer(video);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
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

  void _showDownloadSuccess(String videoName) {
    _showSnackBar('Downloading "$videoName"', isError: false);
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

  String _formatViews(int views) {
    if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
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
                            'Videos',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_filteredVideos.length} videos • Family collection',
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
                          hintText: 'Search videos...',
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
                                  _filterVideos();
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

              // Videos grid/list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue.shade300,
                          size: 30,
                        ),
                      )
                    : _filteredVideos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.video_library,
                                  size: 80,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No videos found',
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
                                  label: const Text('Upload Videos'),
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
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredVideos.length,
      itemBuilder: (context, index) {
        final video = _filteredVideos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => _showVideoOptions(video),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    video.color.withOpacity(0.3),
                    video.color.withOpacity(0.1),
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.video_library,
                              size: 40,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.name.length > 15
                              ? '${video.name.substring(0, 15)}...'
                              : video.name,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${video.duration} • ${video.resolution}',
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Duration badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: GoogleFonts.montserrat(
                          fontSize: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Favorite indicator
                  if (video.isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  
                  // Views count
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 8,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatViews(video.views),
                            style: GoogleFonts.montserrat(
                              fontSize: 8,
                              color: Colors.white,
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
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredVideos.length,
      itemBuilder: (context, index) {
        final video = _filteredVideos[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildVideoTile(video),
        );
      },
    );
  }

  Widget _buildVideoTile(VideoItem video) {
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
        onTap: () => _showVideoOptions(video),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Video thumbnail
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                      color: video.color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.video_library,
                        color: Colors.white.withOpacity(0.5),
                        size: 30,
                      ),
                    ),
                  ),
                  
                  // Play button overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  
                  // Duration badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: GoogleFonts.montserrat(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Video details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name,
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
                      video.fileName,
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
                          video.modifiedBy,
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
                          video.modified,
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
                            video.size,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            video.resolution,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.blue.shade200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 10,
                              color: Colors.white38,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _formatViews(video.views),
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white60,
                              ),
                            ),
                          ],
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
                    icon: video.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onTap: () {
                      setState(() {
                        video.isFavorite = !video.isFavorite;
                      });
                      _showSnackBar(
                        video.isFavorite ? 'Added to favorites' : 'Removed from favorites',
                        isError: false,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Icons.play_arrow,
                    color: Colors.green,
                    onTap: () => _showVideoPlayer(video),
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    icon: Icons.share,
                    color: Colors.blue,
                    onTap: () => _showShareOptions(video),
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

// Video Upload Bottom Sheet
class VideoUploadBottomSheet extends StatefulWidget {
  const VideoUploadBottomSheet({super.key});

  @override
  State<VideoUploadBottomSheet> createState() => _VideoUploadBottomSheetState();
}

class _VideoUploadBottomSheetState extends State<VideoUploadBottomSheet> {
  final List<VideoUploadItem> _videos = [];
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the current video being added
  final _videoNameController = TextEditingController();
  final _fileNameController = TextEditingController();
  final _durationController = TextEditingController();
  final _resolutionController = TextEditingController();
  final _folderController = TextEditingController();
  final _locationController = TextEditingController();
  final _peopleController = TextEditingController();
  
  bool _isAddingVideo = false;

  @override
  void dispose() {
    _videoNameController.dispose();
    _fileNameController.dispose();
    _durationController.dispose();
    _resolutionController.dispose();
    _folderController.dispose();
    _locationController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _addVideoToList() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _videos.add(VideoUploadItem(
          videoName: _videoNameController.text,
          fileName: _fileNameController.text,
          duration: _durationController.text,
          resolution: _resolutionController.text,
          folder: _folderController.text,
          location: _locationController.text,
          people: _peopleController.text,
          fileSize: _generateRandomSize(),
        ));
        
        // Clear controllers for next video
        _videoNameController.clear();
        _fileNameController.clear();
        _durationController.clear();
        _resolutionController.clear();
        _folderController.clear();
        _locationController.clear();
        _peopleController.clear();
        _isAddingVideo = false;
      });
    }
  }

  String _generateRandomSize() {
    final sizes = ['120 MB', '256 MB', '89 MB', '320 MB', '180 MB', '95 MB'];
    return sizes[_videos.length % sizes.length];
  }

  void _removeVideo(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  void _submitVideos() {
    if (_videos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one video'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Return the list of videos
    Navigator.pop(context, _videos.map((video) => video.toMap()).toList());
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
                    'Upload Videos',
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
            
            // Videos list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // List of added videos
                    if (_videos.isNotEmpty) ...[
                      ...List.generate(_videos.length, (index) {
                        final video = _videos[index];
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
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.video_library,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.videoName,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${video.fileName} • ${video.fileSize} • ${video.duration}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    if (video.folder.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          'Folder: ${video.folder}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            color: Colors.red.shade200,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeVideo(index),
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
                    
                    // Add new video form
                    if (_isAddingVideo)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Video Name
                              TextFormField(
                                controller: _videoNameController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Video Name',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Family Vacation 2024',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.video_library, color: Colors.red.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade300),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter video name';
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
                                  hintText: 'e.g., vacation_2024.mp4',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.insert_drive_file, color: Colors.red.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade300),
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
                              
                              // Duration and Resolution row
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _durationController,
                                      style: GoogleFonts.montserrat(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Duration',
                                        labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                        hintText: 'e.g., 5:30',
                                        hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                        prefixIcon: Icon(Icons.timer, color: Colors.red.shade300),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white24),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red.shade300),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _resolutionController,
                                      style: GoogleFonts.montserrat(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Resolution',
                                        labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                        hintText: 'e.g., 1080p',
                                        hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                        prefixIcon: Icon(Icons.high_quality, color: Colors.red.shade300),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white24),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red.shade300),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Folder
                              TextFormField(
                                controller: _folderController,
                                style: GoogleFonts.montserrat(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Folder (Optional)',
                                  labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                                  hintText: 'e.g., Vacation, Holidays',
                                  hintStyle: GoogleFonts.montserrat(color: Colors.white30),
                                  prefixIcon: Icon(Icons.folder, color: Colors.red.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade300),
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
                                  prefixIcon: Icon(Icons.location_on, color: Colors.red.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade300),
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
                                  prefixIcon: Icon(Icons.people, color: Colors.red.shade300),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade300),
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
                                          _isAddingVideo = false;
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
                                      onPressed: _addVideoToList,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade800,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Add Video'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isAddingVideo)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isAddingVideo = true;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                  'Add Another Video',
                                  style: GoogleFonts.montserrat(),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade300,
                                  side: BorderSide(color: Colors.red.shade300),
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
                      onPressed: _submitVideos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Upload ${_videos.length} Video${_videos.length != 1 ? 's' : ''}',
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

class VideoUploadItem {
  final String videoName;
  final String fileName;
  final String duration;
  final String resolution;
  final String folder;
  final String location;
  final String people;
  final String fileSize;

  VideoUploadItem({
    required this.videoName,
    required this.fileName,
    required this.duration,
    required this.resolution,
    required this.folder,
    required this.location,
    required this.people,
    required this.fileSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'videoName': videoName,
      'fileName': fileName,
      'duration': duration,
      'resolution': resolution,
      'folder': folder,
      'location': location,
      'people': people,
      'fileSize': fileSize,
    };
  }
}

class VideoItem {
  final String name;
  final String fileName;
  final String size;
  final String duration;
  final String resolution;
  final String modified;
  final String modifiedBy;
  final Color color;
  final String? thumbnailUrl;
  final String? folder;
  bool isFavorite;
  final String? location;
  final List<String>? people;
  final int views;

  VideoItem({
    required this.name,
    required this.fileName,
    required this.size,
    required this.duration,
    required this.resolution,
    required this.modified,
    required this.modifiedBy,
    required this.color,
    this.thumbnailUrl,
    this.folder,
    this.isFavorite = false,
    this.location,
    this.people,
    required this.views,
  });
}