
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/local/transaction_local_data_source.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'presentation/cubit/transaction_cubit.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  final sharedPrefs = await SharedPreferences.getInstance();
  
  // Dependency Injection Setup
  final localDataSource = TransactionLocalDataSourceImpl(sharedPreferences: sharedPrefs);
  final repository = TransactionRepositoryImpl(localDataSource: localDataSource);

  runApp(FinFlowApp(repository: repository));
}

class FinFlowApp extends StatelessWidget {
  final TransactionRepositoryImpl repository;

  const FinFlowApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionCubit(repository: repository)..loadTransactions(),
        ),
      ],
      child: MaterialApp(
        title: 'FinFlow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto', // Default standard font
          // Define base colors here for reuse if needed globally
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF10B981),
            brightness: Brightness.dark,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}