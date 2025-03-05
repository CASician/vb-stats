import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vb_stats/db/database.dart';
import 'package:vb_stats/models/match.dart';
import 'package:vb_stats/models/team.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({Key? key}) : super(key: key);

  @override
  _CreateMatchScreenState createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Team> _teams = [];
  int? _selectedTeamId;
  DateTime? _selectedDate;
  final TextEditingController _opponentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teams = await DatabaseHelper.instance.getAllTeams();
    setState(() {
      _teams = teams;
      if (_teams.isNotEmpty) {
        // Imposta la prima squadra come default
        _selectedTeamId = _teams.first.id;
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveMatch() async {
    if (_formKey.currentState!.validate() && _selectedTeamId != null && _selectedDate != null) {
      // Crea il match
      Match match = Match(
        team: _selectedTeamId!,
        opponent: _opponentController.text,
        date: _selectedDate!,
      );
      await DatabaseHelper.instance.insertMatch(match);
      Navigator.pop(context); // Torna indietro dopo il salvataggio
    }
  }

  @override
  void dispose() {
    _opponentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Partita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _teams.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown per selezionare la squadra in casa
              DropdownButtonFormField<int>(
                value: _selectedTeamId,
                items: _teams.map((team) {
                  return DropdownMenuItem<int>(
                    value: team.id,
                    child: Text(team.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeamId = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Squadra in casa',
                ),
                validator: (value) => value == null ? 'Seleziona una squadra' : null,
              ),
              const SizedBox(height: 16),
              // Date picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Seleziona la data della partita'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Scegli Data'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Campo per l'avversario
              TextFormField(
                controller: _opponentController,
                decoration: const InputDecoration(
                  labelText: 'Squadra avversaria',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il nome dell\'avversario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Bottone per salvare la partita
              ElevatedButton(
                onPressed: _saveMatch,
                child: const Text('Salva Partita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
