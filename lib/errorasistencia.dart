import 'package:flutter/material.dart';

class ErrrorAsistencia extends StatefulWidget {
  const ErrrorAsistencia({super.key});

  @override
  State<ErrrorAsistencia> createState() => _ErrrorAsistenciaState();
}

class _ErrrorAsistenciaState extends State<ErrrorAsistencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        title: const Text('Error Asistencia'),
        centerTitle: true,
      ),
      body:  Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text('ERROR: NO RECONOCE LA FOTO TOMADA',
              style: TextStyle(fontSize: 25),),
            ),
            Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.orangeAccent,
                  textStyle: const TextStyle(fontSize: 20),
                  ),
              onPressed: (){
                Navigator.pushNamed(context, '/asistencia');
              }, 
              child: const Text('Finalizar',textAlign: TextAlign.center,),
            ),
            )
          ],
        ),
      ),
    );
  }
}