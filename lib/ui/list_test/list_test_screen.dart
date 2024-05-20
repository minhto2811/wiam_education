import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/ui/home/components/lesson_today.dart';
import 'package:wiam/ui/test_detail/test_detail_screen.dart';

import '../../bloc/list_test/list_test_bloc.dart';
import '../../data/models/test.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';

class ListTestScreen extends StatelessWidget {
  static const String route = '/list_test';

  const ListTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('extend.try_hard')),
        titleTextStyle: const TextStyle(fontFamily: 'Bungee', fontSize: 20.0),
        backgroundColor: const Color(0xFF5AC2C1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            getIt<PlayerManager>().playWhenClick();
            Navigator.pop(context);
          },
        ),
      ),
      body: const TestBody(),
    );
  }
}

class TestBody extends StatefulWidget {
  const TestBody({super.key});

  @override
  State<TestBody> createState() => _TestBodyState();
}

class _TestBodyState extends State<TestBody> {
  final ListTestBloc _testBloc = getIt<ListTestBloc>();

  @override
  void initState() {
    _testBloc.add(ListTestInitialEvent(context));
    super.initState();
  }

  @override
  void dispose() {
    _testBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListTestBloc, ListTestState>(
      bloc: _testBloc,
      builder: (context, state) {
        if (state is ListTestLoadingState) {
          return Center(
            child: MyPlaceHolder(
                message: translate('lesson_today.loading'),
                image: 'assets/animations/bird_animation.json'),
          );
        } else if (state is ListTestCompletedState) {
          if (state.tests.isEmpty) {
            return Center(
              child: MyPlaceHolder(
                  message: translate('lesson_today.empty'),
                  image: 'assets/animations/bird_animation.json'),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) => TestItem(state.tests[index]),
              itemCount: state.tests.length);
        }
        return const SizedBox();
      },
      listener: (context, state) {
        if (state is ListTestCompletedState && state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
    );
  }
}

class TestItem extends StatelessWidget {
  final Test _test;

  const TestItem(this._test, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        borderRadius:  BorderRadius.circular(10.0),
        onTap: (){
            getIt<PlayerManager>().playWhenClick();
            Navigator.pushNamed(context, TestDetailScreen.route, arguments: _test);
        },
        child: ListTile(
          title: Text(_test.title),
          trailing: const Icon(Icons.book_outlined),
        ),
      ),
    );
  }
}
