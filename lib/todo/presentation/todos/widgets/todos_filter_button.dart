import 'package:bloc_tutorial/todo/l10n/l10n.dart';
import 'package:bloc_tutorial/todo/presentation/todos/todos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosFilterButton extends StatelessWidget {
  const TodosFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter = context.select((TodosBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.todosOverviewFilterTooltip,
      onSelected: (filter) {
        context.read<TodosBloc>().add(TodoFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text(l10n.todosOverviewFilterAll),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text(l10n.todosOverviewFilterActiveOnly),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text(l10n.todosOverviewFilterCompletedOnly),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
