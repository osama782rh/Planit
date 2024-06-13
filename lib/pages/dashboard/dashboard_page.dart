import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
      ),
      backgroundColor: Color(0xFF6A0DAD), // Fond de l'application en violet
      body: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: Image.asset(
              'assets/images/acceuil.png',
              width: 250,
              height: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Planit',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Cursive',
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ListView(
                      children: [
                        _buildDashboardButton(
                          context,
                          icon: Icons.check_circle_outline,
                          label: 'Voir les tâches',
                          onPressed: () {
                            Navigator.pushNamed(context, '/task_list');
                          },
                        ),
                        _buildDashboardButton(
                          context,
                          icon: Icons.person_outline,
                          label: 'Voir le profil',
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                        _buildDashboardButton(
                          context,
                          icon: Icons.calendar_today_outlined,
                          label: 'Voir les calendriers',
                          onPressed: () {
                            Navigator.pushNamed(context, '/calendars');
                          },
                        ),
                        _buildDashboardButton(
                          context,
                          icon: Icons.contacts_outlined,
                          label: 'Voir les contacts',
                          onPressed: () {
                            Navigator.pushNamed(context, '/contacts');
                          },
                        ),
                        _buildDashboardButton(
                          context,
                          icon: Icons.exit_to_app,
                          label: 'Se déconnecter',
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 200, // Fixer la largeur des boutons
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.white, // Fond des boutons en blanc
              foregroundColor: Colors.black, // Écriture et icônes en noir
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Icon(icon, size: 16), // Réduction de la taille de l'icône
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12), // Réduction de la taille du texte
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
