import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/models/babies.dart';
import 'package:provider_example/models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Dog>(
          create: (context) => Dog(breed: 'Breed08', name: 'dog08', age: 3),
        ),
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final int dogAge = context.read<Dog>().age;
            final babies = Babies(age: dogAge);
            return babies.getBabies();
          },
        ),
        StreamProvider(
          create: (context) {
            final int dogAge = context.read<Dog>().age;
            final babies = Babies(age: dogAge * 2);
            return babies.bark();
          },
          initialData: 'Bark 0 times',
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider_08'),
        centerTitle: true,
      ),
      body: Consumer<Dog>(
        builder: (BuildContext context, Dog dog, Widget? child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '- name: ${dog.name}',
                  style: const TextStyle(fontSize: 20),
                ),
                const BreedAndDog(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BreedAndDog extends StatelessWidget {
  const BreedAndDog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Dog>(
      builder: (BuildContext context, Dog dog, Widget? child) {
        return Column(
          children: [
            Text(
              '- breed: ${dog.breed}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Age(),
          ],
        );
      },
    );
  }
}

class Age extends StatelessWidget {
  const Age({
    super.key,
    g,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Dog>(
      builder: (_, dog, __) {
        return Column(
          children: [
            Text(
              '- age: ${dog.age}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- number of babies: ${context.watch<int>()}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- ${context.watch<String>()}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => dog.grow(),
              child: const Text(
                'Grow',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
