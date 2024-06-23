import 'package:flutter/material.dart';

class Asistencia extends StatefulWidget {
  const Asistencia({super.key});

  @override
  State<Asistencia> createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(120),
                backgroundColor: Colors.orangeAccent,
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Column(
              children:[
              Image(
                height: 70,
                image: AssetImage('assets/logoasistencia.png')),
                SizedBox(width: 10),
                Text(
                  'ASISTENCIA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black),
                    ),
              ]),
          onPressed: () async{
            Navigator.pushNamed(context, '/procesoasistencia');
          },
          ),
          ],
        )
      ),
    );
  }
}