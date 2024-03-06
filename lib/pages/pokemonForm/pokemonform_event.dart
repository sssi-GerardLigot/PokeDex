import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PokemonFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonFormSubmitted extends PokemonFormEvent {
  final BuildContext context;
  final bool addPokemon;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descriptionController;
  final String? selectedMon;

  PokemonFormSubmitted(
      {required this.context,
      required this.addPokemon,
      required this.nameController,
      required this.typeController,
      required this.descriptionController,
      this.selectedMon});

  @override
  List<Object?> get props => [context, nameController, typeController, descriptionController, selectedMon, addPokemon];
}
