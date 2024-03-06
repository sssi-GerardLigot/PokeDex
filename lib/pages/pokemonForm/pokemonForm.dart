import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/components/button1.dart';
import 'package:pokedex/components/my_textfield.dart';
import 'package:pokedex/pages/homepage/homepage_bloc.dart';
import 'package:pokedex/pages/pokemonForm/pokemonform_bloc.dart';
import 'package:pokedex/pages/pokemonForm/pokemonform_event.dart';
import 'package:pokedex/services/database_helper.dart';

class PokemonForm extends StatefulWidget {
  Map<String, dynamic>? pokemonToEdit;
  bool addPokemon;
  PokemonForm({
    Key? key,
    this.pokemonToEdit,
    required this.addPokemon,
  }) : super(key: key);

  @override
  State<PokemonForm> createState() => _PokemonFormState();
}

class _PokemonFormState extends State<PokemonForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pokemonToEdit != null) {
      nameController.text = widget.pokemonToEdit!['name'];
      typeController.text = widget.pokemonToEdit!['type'];
      descriptionController.text = widget.pokemonToEdit!['description'];

    }
  }
  @override
  Widget build(BuildContext context) {
    bool addPokemon = widget.addPokemon;
    return BlocProvider(
      create: (context) => PokemonFormBloc(SQLHelper()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title:  Text(addPokemon == true ? "Add Pokemon": "Update Pokemon",
            style: TextStyle(
                fontFamily: "Outfit",
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyTextField(
                height: 25,
                label: "Name:",
                controller: nameController,
                hintText: "Enter Name: ",
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  height: 25,
                  label: "Type:",
                  controller: typeController,
                  hintText: "Enter Type: "
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  height: 40,
                  label: "Description:",
                  controller: descriptionController,
                  hintText: "Enter Description: "
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if(widget.addPokemon == true){
                          BlocProvider.of<PokemonFormBloc>(context).add(
                            PokemonFormSubmitted(
                              context: context,
                              addPokemon: addPokemon,
                              nameController: nameController,
                              typeController: typeController,
                              descriptionController: descriptionController,
                            ),
                          );
                        }else if(widget.addPokemon == false){
                          String selectedMon = widget.pokemonToEdit!['name'];
                          BlocProvider.of<PokemonFormBloc>(context).add(
                            PokemonFormSubmitted(
                              context: context,
                              addPokemon: addPokemon,
                              nameController: nameController,
                              typeController: typeController,
                              descriptionController: descriptionController,
                              selectedMon: selectedMon,
                            ),
                          );
                        }
                      },
                      child: Text(addPokemon == true ? "Save": "Update")),
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("Cancel")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
