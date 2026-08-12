import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';

class DownloadPanel extends StatefulWidget {
  const DownloadPanel({super.key});
  static const String routeName = '/downloads';

  @override
  State<DownloadPanel> createState() => _DownloadPanelState();
}

class _DownloadPanelState extends State<DownloadPanel>
    with SingleTickerProviderStateMixin {
  late List<DownloadedVideo> downloadedVideos;
  late List<DownloadedPdf> downloadedPDFs;
  bool _isGridView = true;
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    downloadedPDFs = [
      DownloadedPdf(
        id: 'p1',
        title: 'Flutter Cheat Sheet',
        author: 'Flutter Team',
        fileSize: '2.4 MB',
        totalSize: 2,
        pages: 5,
        date: '2 days ago',
      ),
      DownloadedPdf(
        id: 'p2',
        title: 'Dart Language Specification',
        author: 'Google',
        fileSize: '4.1 MB',
        totalSize: 4,
        pages: 184,
        date: '1 week ago',
      ),
    ];
    // Demo data - replace with actual data from your API/database
    downloadedVideos = [
      DownloadedVideo(
        id: '1',
        title: 'Flutter Fundamentals',
        instructor: 'John Doe',
        duration: '45:30',
        fileSize: '256 MB',
        thumbnail: 'assets/images/course1.png',
        progress: 100,
        watchedDuration: '45:30',
        totalSize: 256,
        downloadedSize: 256,
      ),
      DownloadedVideo(
        id: '2',
        title: 'Advanced Dart Concepts',
        instructor: 'Jane Smith',
        duration: '38:15',
        fileSize: '198 MB',
        thumbnail: 'assets/images/course2.png',
        progress: 100,
        watchedDuration: '15:20',
        totalSize: 198,
        downloadedSize: 198,
      ),
      DownloadedVideo(
        id: '3',
        title: 'State Management Patterns',
        instructor: 'Mike Johnson',
        duration: '52:45',
        fileSize: '312 MB',
        thumbnail: 'assets/images/course3.png',
        progress: 100,
        watchedDuration: '32:10',
        totalSize: 312,
        downloadedSize: 312,
      ),
      DownloadedVideo(
        id: '4',
        title: 'Firebase Integration',
        instructor: 'Sarah Williams',
        duration: '41:20',
        fileSize: '287 MB',
        thumbnail: 'assets/images/course4.png',
        progress: 100,
        watchedDuration: '41:20',
        totalSize: 287,
        downloadedSize: 287,
      ),
      DownloadedVideo(
        id: '5',
        title: 'Mobile App Architecture',
        instructor: 'Emily Brown',
        duration: '48:50',
        fileSize: '295 MB',
        thumbnail: 'assets/images/course5.png',
        progress: 100,
        watchedDuration: '0:00',
        totalSize: 295,
        downloadedSize: 295,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: InternetConnectivityChecker().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetPage();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetPage();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: _buildAppBar(),
          body: TabBarView(
            controller: _tabController,
            children: [
              downloadedVideos.isEmpty
                  ? _buildEmptyState('Videos')
                  : _buildMainContent(),
              downloadedPDFs.isEmpty
                  ? _buildEmptyState('PDFs')
                  : _buildPdfMainContent(),
            ],
          ),
        );
      }
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(184),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue,
              AppColors.primaryBlue.withValues(alpha: 0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('My Downloads'),
              // leading: IconButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   icon: Icon(Icons.arrow_back_ios),
              // ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              actions: [
                // if (_tabController.index == 0)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        _isGridView
                            ? Icons.view_list_rounded
                            : Icons.grid_view_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Text()
                // Padding(
                //   padding: const EdgeInsets.only(right: 8),
                //   child: IconButton(
                //     icon: Icon(
                //       _isGridView ? Icons.list : Icons.dashboard,
                //       size: 24,
                //     ),
                //     onPressed: () {
                //       setState(() {
                //         _isGridView = !_isGridView;
                //       });
                //     },
                //     splashRadius: 24,
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.download_done,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${downloadedVideos.length} Videos',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storage,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${downloadedVideos.fold<int>(0, (sum, v) => sum + v.totalSize)} MB',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(text: 'Videos'),
                      Tab(text: 'PDFs'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return _isGridView ? _buildVideoGrid() : _buildVideoList();
  }

  Widget _buildPdfMainContent() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: downloadedPDFs.length,
      itemBuilder: (context, index) {
        final pdf = downloadedPDFs[index];
        return _PdfListItem(
          pdf: pdf,
          onTap: () {},
          onShare: () {},
          onDelete: () {},
        );
      },
    );
  }

  Widget _buildEmptyState([String type = 'Videos']) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlueLight,
                    AppColors.primaryBlueLighter,
                  ],
                ),
              ),
              child: Icon(
                Icons.cloud_download_outlined,
                size: 56,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Downloaded $type',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Download your favorite courses to watch them offline anytime, anywhere.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore),
              label: const Text('Browse Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: .55,
            children: List.generate(
              downloadedVideos.length,
              (index) => _AnimatedVideoCard(
                video: downloadedVideos[index],
                onTap: () => _showVideoDetails(downloadedVideos[index]),
                onDelete: () => _deleteVideo(downloadedVideos[index].id),
                onShare: () => _shareVideo(downloadedVideos[index].id),
                delay: Duration(milliseconds: index * 50),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoList() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          sliver: SliverList.builder(
            itemCount: downloadedVideos.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AnimatedVideoListItem(
                video: downloadedVideos[index],
                onTap: () => _showVideoDetails(downloadedVideos[index]),
                onDelete: () => _deleteVideo(downloadedVideos[index].id),
                onShare: () => _shareVideo(downloadedVideos[index].id),
                delay: Duration(milliseconds: index * 50),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showVideoDetails(DownloadedVideo video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildVideoDetailsSheet(video),
    );
  }

  Widget _buildVideoDetailsSheet(DownloadedVideo video) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryBlue,
                              AppColors.primaryBlueDark,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              video.instructor,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard(
                        icon: Icons.timer,
                        label: 'Duration',
                        value: video.duration,
                      ),
                      _buildInfoCard(
                        icon: Icons.storage,
                        label: 'Size',
                        value: video.fileSize,
                      ),
                      _buildInfoCard(
                        icon: Icons.check_circle,
                        label: 'Downloaded',
                        value: '100%',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Watch Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(video),
                  const SizedBox(height: 16),
                  Text(
                    '${video.watchedDuration} / ${video.duration}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showVideoDetails(video);
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _shareVideo(video.id);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteVideo(video.id);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(DownloadedVideo video) {
    final watchedMinutes = _parseTime(video.watchedDuration);
    final totalMinutes = _parseTime(video.duration);
    final progress = totalMinutes > 0 ? watchedMinutes / totalMinutes : 0.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.9
                  ? Colors.green[500]!
                  : progress > 0.5
                  ? AppColors.accentOrange
                  : AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  double _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      return int.parse(parts[0]) * 60 + int.parse(parts[1]).toDouble();
    }
    return 0;
  }

  void _deleteVideo(String videoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download?'),
        content: const Text(
          'This video will be removed from your downloads. You can download it again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                downloadedVideos.removeWhere((v) => v.id == videoId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Video deleted'),
                  backgroundColor: Colors.red[400],
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareVideo(String videoId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share link copied to clipboard'),
        backgroundColor: AppColors.primaryBlue,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

class _AnimatedVideoCard extends StatefulWidget {
  final DownloadedVideo video;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Duration delay;

  const _AnimatedVideoCard({
    required this.video,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
    required this.delay,
  });

  @override
  State<_AnimatedVideoCard> createState() => _AnimatedVideoCardState();
}

class _AnimatedVideoCardState extends State<_AnimatedVideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(opacity: _opacityAnimation, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Thumbnail gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBlue.withValues(alpha: 0.8),
                      AppColors.primaryBlueDark.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail area
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        // Background video icon
                        Positioned.fill(
                          child: Icon(
                            Icons.videocam,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        // Play button - centered
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.accentOrange.withValues(
                                alpha: 0.95,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentOrange.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        // Duration badge
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.video.duration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info section
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.video.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.video.instructor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.video.fileSize,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${((widget.video.downloadedSize / widget.video.totalSize) * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    onTap: widget.onTap,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.play_arrow, size: 18),
                                        SizedBox(width: 12),
                                        Text('Play'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: widget.onShare,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.share, size: 18),
                                        SizedBox(width: 12),
                                        Text('Share'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: widget.onDelete,
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 18,
                                  color: Colors.grey[600],
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
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedVideoListItem extends StatefulWidget {
  final DownloadedVideo video;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Duration delay;

  const _AnimatedVideoListItem({
    required this.video,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
    required this.delay,
  });

  @override
  State<_AnimatedVideoListItem> createState() => _AnimatedVideoListItemState();
}

class _AnimatedVideoListItemState extends State<_AnimatedVideoListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: _buildListItem(),
      ),
    );
  }

  Widget _buildListItem() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue.withValues(alpha: 0.8),
                    AppColors.primaryBlueDark.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Icon(
                      Icons.videocam,
                      size: 32,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.video.instructor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.video.duration,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.storage, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.video.fileSize,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Menu button
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: widget.onTap,
                  child: Row(
                    children: const [
                      Icon(Icons.play_arrow, size: 18),
                      SizedBox(width: 12),
                      Text('Play'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: widget.onShare,
                  child: Row(
                    children: const [
                      Icon(Icons.share, size: 18),
                      SizedBox(width: 12),
                      Text('Share'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: widget.onDelete,
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadedVideo {
  final String id;
  final String title;
  final String instructor;
  final String duration;
  final String fileSize;
  final String thumbnail;
  final int progress;
  final String watchedDuration;
  final int totalSize;
  final int downloadedSize;

  DownloadedVideo({
    required this.id,
    required this.title,
    required this.instructor,
    required this.duration,
    required this.fileSize,
    required this.thumbnail,
    required this.progress,
    required this.watchedDuration,
    required this.totalSize,
    required this.downloadedSize,
  });
}

class DownloadedPdf {
  final String id;
  final String title;
  final String author;
  final String fileSize;
  final int totalSize;
  final int pages;
  final String date;

  DownloadedPdf({
    required this.id,
    required this.title,
    required this.author,
    required this.fileSize,
    required this.totalSize,
    required this.pages,
    required this.date,
  });
}

class _PdfListItem extends StatelessWidget {
  final DownloadedPdf pdf;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const _PdfListItem({
    required this.pdf,
    required this.onTap,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // PDF Icon Container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pdf.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pdf.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.insert_drive_file_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pdf.pages} Pages',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.storage,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            pdf.fileSize,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Menu button
                PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      onTap: onShare,
                      child: Row(
                        children: const [
                          Icon(Icons.share, size: 18),
                          SizedBox(width: 12),
                          Text('Share'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: onDelete,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
