import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/components/button1.dart';
import 'package:pokedex/components/pokemonCard.dart';
import 'package:pokedex/pages/homepage/homepage_bloc.dart';
import 'package:pokedex/pages/homepage/homepage_event.dart';
import 'package:pokedex/pages/homepage/homepage_state.dart';
import 'package:pokedex/pages/pokemonForm/pokemonForm.dart';
import 'package:pokedex/pages/pokemonForm/pokemonform_bloc.dart';
import 'package:pokedex/services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;
  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(SQLHelper());
    _homeBloc.add(FetchPokemonData(context));
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          "PokeDex",
          style: TextStyle(
              fontFamily: "Outfit", fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Center(
          child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is PokemonDeleted || state is PokemonDataLoaded) {
            _homeBloc.add(FetchPokemonData(context));
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
            bloc: _homeBloc,
            builder: (context, state) {
              if (state is PokemonDataLoading) {
                return const CircularProgressIndicator();
              } else if (state is PokemonDataLoaded) {
                print("BlocBuilder in HomePage is rebuilding");
                return ListView.builder(
                    itemCount: state.pokemonData.length,
                    itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: PokemonCard(
                            index: index,
                            name: state.pokemonData[index]['name'],
                            type: state.pokemonData[index]['type'],
                            description: state.pokemonData[index]
                                ['description'],
                            edit: () {
                              context.read<HomeBloc>().add(EditPokemon(state.pokemonData[index], context));
                            },
                            delete: () {
                              context.read<HomeBloc>().add(DeletePokemon(
                                  state.pokemonData[index]['name'], context));
                            },
                          ),
                        ));
              } else if (state is PokemonDataError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            }),
      )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              print("add button has been pressed");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: _homeBloc,
                    child: PokemonForm(addPokemon: true,),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _homeBloc.add(ClearDatabaseTable(context)),
            child: const Icon(Icons.delete_forever),
          ),
        ],
      ),
    );
  }
}