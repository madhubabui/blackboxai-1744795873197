import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../config/constants.dart';
import '../providers/status_provider.dart';
import '../widgets/status_grid_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';
import '../widgets/permission_request.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.storage.status;
    setState(() {
      _hasPermission = status.isGranted;
    });
    if (_hasPermission) {
      _loadStatuses();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
    if (_hasPermission) {
      _loadStatuses();
    }
  }

  Future<void> _loadStatuses() async {
    final provider = Provider.of<StatusProvider>(context, listen: false);
    await provider.loadStatuses();
  }

  void _showSortMenu() {
    final provider = Provider.of<StatusProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Newest First'),
            onTap: () {
              provider.setSortBy(SortBy.newest);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time_filled),
            title: const Text('Oldest First'),
            onTap: () {
              provider.setSortBy(SortBy.oldest);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Size'),
            onTap: () {
              provider.setSortBy(SortBy.size);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              provider.inSelectionMode
                  ? '${provider.selectedCount} Selected'
                  : AppConstants.appName,
            ),
            actions: _buildAppBarActions(provider),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'All',
                  icon: const Icon(Icons.grid_view_rounded),
                ),
                Tab(
                  text: 'Images (${provider.imageCount})',
                  icon: const Icon(Icons.image_rounded),
                ),
                Tab(
                  text: 'Videos (${provider.videoCount})',
                  icon: const Icon(Icons.videocam_rounded),
                ),
              ],
            ),
          ),
          body: !_hasPermission
              ? PermissionRequest(onRequest: _requestPermission)
              : _buildBody(provider),
          floatingActionButton: _buildFAB(provider),
        );
      },
    );
  }

  Widget _buildBody(StatusProvider provider) {
    if (provider.isLoading) {
      return const LoadingState();
    }

    if (provider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStatuses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildStatusGrid(provider, StatusType.all),
        _buildStatusGrid(provider, StatusType.image),
        _buildStatusGrid(provider, StatusType.video),
      ],
    );
  }

  Widget _buildStatusGrid(StatusProvider provider, StatusType type) {
    provider.setStatusType(type);
    final statuses = provider.statuses;

    if (statuses.isEmpty) {
      return EmptyState(
        icon: type == StatusType.video
            ? Icons.videocam_off_rounded
            : Icons.image_not_supported_rounded,
        message: 'No ${type.name} statuses found',
        onRefresh: _loadStatuses,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadStatuses,
      child: MasonryGridView.count(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        mainAxisSpacing: AppConstants.gridSpacing,
        crossAxisSpacing: AppConstants.gridSpacing,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          return StatusGridItem(
            status: statuses[index],
            onTap: () {
              if (provider.inSelectionMode) {
                provider.toggleStatusSelection(statuses[index]);
              } else {
                Navigator.pushNamed(
                  context,
                  '/preview',
                  arguments: statuses[index],
                );
              }
            },
            onLongPress: () {
              if (!provider.inSelectionMode) {
                provider.toggleSelectionMode();
                provider.toggleStatusSelection(statuses[index]);
              }
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions(StatusProvider provider) {
    if (provider.inSelectionMode) {
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: provider.selectAll,
        ),
        IconButton(
          icon: const Icon(Icons.save_alt),
          onPressed: provider.selectedCount > 0
              ? () async {
                  await provider.saveSelectedStatuses();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppConstants.successMultipleStatusesSaved),
                    ),
                  );
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: provider.selectedCount > 0
              ? () async {
                  await provider.deleteSelectedStatuses();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppConstants.successMultipleStatusesDeleted),
                    ),
                  );
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: provider.clearSelection,
        ),
      ];
    }
    return [
      IconButton(
        icon: const Icon(Icons.sort),
        onPressed: _showSortMenu,
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.pushNamed(context, '/settings'),
      ),
    ];
  }

  Widget? _buildFAB(StatusProvider provider) {
    if (!provider.inSelectionMode && !provider.isLoading) {
      return FloatingActionButton(
        onPressed: _loadStatuses,
        child: const Icon(Icons.refresh),
      );
    }
    return null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
