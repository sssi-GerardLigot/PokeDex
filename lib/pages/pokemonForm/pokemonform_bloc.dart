import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/pages/homepage/homepage_bloc.dart';
import 'package:pokedex/pages/homepage/homepage_event.dart';
import 'package:pokedex/pages/pokemonForm/pokemonform_event.dart';
import 'package:pokedex/pages/pokemonForm/pokemonform_state.dart';
import 'package:pokedex/services/database_helper.dart';

class PokemonFormBloc extends Bloc<PokemonFormEvent, PokemonFormState> {
  final SQLHelper _databaseHelper;

  PokemonFormBloc(this._databaseHelper) : super(PokemonFormInitial()) {

    on<PokemonFormSubmitted>((event, emit) async {
      emit(PokemonFormLoading());
      try {
        if(event.nameController.text.isNotEmpty &&
            event.typeController.text.isNotEmpty &&
            event.descriptionController.text.isNotEmpty){
          if (event.addPokemon == true) {
            await _databaseHelper.addPokemon(
                event.context,
                event.nameController.text,
                event.typeController.text,
                event.descriptionController.text);
          } else if (event.addPokemon == false) {
            await _databaseHelper.updatePokemon(
                event.context,
                event.selectedMon.toString(),
                event.nameController.text.toString(),
                event.typeController.text.toString(),
                event.descriptionController.text.toString()
            );
          }
          event.nameController.clear();
          event.typeController.clear();
          event.descriptionController.clear();
          Navigator.of(event.context).pop();
          print("Dispatching FetchPokemonData from PokemonFormBloc");
          BlocProvider.of<HomeBloc>(event.context)
              .add(FetchPokemonData(event.context));
          print("Refresh Idol");
          emit(PokemonFormSuccess());
        }else{
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(content: Text('All fields are required'))
          );
        }
      } catch (error) {
        emit(PokemonFormFailure(error: error.toString()));
      }
    });
  }
}
