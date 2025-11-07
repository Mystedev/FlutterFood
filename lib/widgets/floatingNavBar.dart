import 'package:flutter/material.dart';

class FloatingNavBar extends StatefulWidget {
  @override
  _FloatingNavBarState createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // permite que la barra flote sobre el fondo
      body: Center(
        child: Text('Página $_index'),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BARRA FLOTANTE POR ENCIMA DE ELEMENTOS
class FloatingNavOverlay extends StatefulWidget {
  const FloatingNavOverlay({super.key});

  @override
  State<FloatingNavOverlay> createState() => _FloatingNavOverlayState();
}

class _FloatingNavOverlayState extends State<FloatingNavOverlay> {
  int _index = 0;

  final List<Widget> _pages = [
    ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 30,
      itemBuilder: (_, i) => ListTile(title: Text('Elemento $i')),
    ),
    const Center(child: Text('Buscar')),
    const Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_index],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BottomNavigationBar(
                  currentIndex: _index,
                  onTap: (i) => setState(() => _index = i),
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Inicio'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: 'Buscar'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'Perfil'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
