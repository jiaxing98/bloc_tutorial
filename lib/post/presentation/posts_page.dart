import 'package:bloc_tutorial/post/data/data_sources/post_data_source.dart';
import 'package:bloc_tutorial/post/domain/blocs/post_bloc.dart';
import 'package:bloc_tutorial/post/domain/models/post.dart';
import 'package:bloc_tutorial/post/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => PostBloc(postDS: sl.get<PostDataSource>())..add(PostFetched()),
        child: const PostList(),
      ),
    );
  }
}

//region PostList
class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (ctx, state) {
        return switch (state.status) {
          PostStatus.initial => const Center(child: CircularProgressIndicator()),
          PostStatus.failure => const Center(child: Text('failed to fetch posts')),
          PostStatus.success => state.posts.isEmpty
              ? const Center(child: Text('no posts'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
                  itemBuilder: (ctx, index) {
                    return index >= state.posts.length
                        ? const BottomLoader()
                        : PostListItem(post: state.posts[index]);
                  },
                ),
        };
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
//endregion

//region PostListItem
class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: ListTile(
        leading: Text("${post.id}", style: textTheme.bodySmall),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
        dense: true,
      ),
    );
  }
}
//endregion

//region BottomLoader
class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
//endregion
