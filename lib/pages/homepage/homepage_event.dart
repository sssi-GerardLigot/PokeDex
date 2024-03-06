import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchPokemonData extends HomeEvent {
  final BuildContext context;
  const FetchPokemonData(this.context);
  @override
  List<Object> get props => [context];

}

class ClearDatabaseTable extends HomeEvent {
  final BuildContext context;
  const ClearDatabaseTable(this.context);
  @override
  List<Object> get props => [context];
}

class DeletePokemon extends HomeEvent {
  final String selectedMon;
  final BuildContext context;
  DeletePokemon(this.selectedMon, this.context);
  @override
  List<Object> get props => [selectedMon, context];
}

class EditPokemon extends HomeEvent {
  final Map<String, dynamic> pokemonToEdit;
  final BuildContext context;
  EditPokemon(this.pokemonToEdit, this.context);
}

