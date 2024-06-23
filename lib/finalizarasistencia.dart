// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:faceapp/servicios/guardar_imagen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FinalizarAsistencia extends StatefulWidget {
  const FinalizarAsistencia({super.key});

  @override
  State<FinalizarAsistencia> createState() => _FinalizarAsistenciaState();
}

class _FinalizarAsistenciaState extends State<FinalizarAsistencia> {
  //String nombre = 'Cesar Zidani Hinostroza Turin';
  String? cursoSeleccionado1;
  String? codigoCursoSeleccionado;
  @override
  Widget build(BuildContext context) {
    final  args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final String codigo = args['codigo'] ?? '';
      final List<Map<String, dynamic>> cursos = List<Map<String, dynamic>>.from(args['cursos'] ?? []);
      final List<String> nombresCursos = cursos.map((curso) => curso['nombre_curso'].toString()).toList();
      final String nombre = args['nombre'];
      //final String token = args['token'];
      final String latitud = args['coordenada x'];
      final String longitud = args['coordenada y'];
      //final String imageUrl = args['imageUrl'];
       final File? imagen = args['image'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Asistencia'),
        centerTitle: true,
      ),
      body:  Center(
        child: Container(
        padding: const EdgeInsets.all(15),
        child:  Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Bienvenido',
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 10,),
            
            Text('$nombre\n$codigo',
              style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            
          const SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: DropdownButtonFormField<String>(
              value: cursoSeleccionado1,
              items: nombresCursos.map(( nombresCursos) {
                return DropdownMenuItem<String>(
                  value:  nombresCursos,
                  child: Text( nombresCursos),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  cursoSeleccionado1 = newValue!;
                  final cursoInfo = cursos.firstWhere((curso) => curso['nombre_curso'] == newValue);
                        codigoCursoSeleccionado = cursoInfo['codigo_curso'];
                });
              },
              decoration: InputDecoration(
                labelText: 'Selecciona curso',
                labelStyle: const TextStyle(color: Colors.blueGrey),
                

                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orangeAccent, width: 2), // Color de la línea cuando el campo está enfocado
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orangeAccent, width: 2), // Color de la línea siempre
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ),
          
            const SizedBox(height: 10,),
            cursoSeleccionado1 == null? const Text(""):Text('Curso seleccionado:\n$cursoSeleccionado1',
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                ),
            const Expanded(child: Text(""),),

            Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.orangeAccent,
                    textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: cursoSeleccionado1 == null?() {showSnackbar('Selecciona un curso');}: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Evita que se cierre al tocar fuera de la ventana
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Cargando...'),
                            content: CircularProgressIndicator(), // Mostrar un indicador de carga
                          );
                          },
                      );
                      final hora = obtenerFechaHoraActual();
                      final imageUrl = await uploadImageAndGetUrl(imagen!);
                      await enviarDatos(codigo, codigoCursoSeleccionado!, hora, true, latitud, longitud, imageUrl!);
                      Navigator.pop(context);
                      mostrarVentanaEmergente(context,codigo, codigoCursoSeleccionado!, hora, latitud, longitud, imageUrl);
                    },
                    child: const Text("Finalizar"),
                    ),
                  ),
             
          ],
        ),
      ),
      ),
    );
    }else{
      return const Center(child: Text('No se proporcionaron argumentos'));
    }
  }

void mostrarVentanaEmergente(BuildContext context, String codigo, String codigoCurso, String hora, String latitud, String longitud, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Asistencia Registrada', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hora registrada: $hora'),
            const SizedBox(height: 10),
            Text('Código estudiante: $codigo'),
            const SizedBox(height: 10),
            Text('Código curso: $codigoCurso'),
            const SizedBox(height: 10),
            Text('Latitud: $latitud'),
            const SizedBox(height: 10,),
            Text('Longitud: $longitud'),
            const SizedBox(height: 10,),
            Image.network(imageUrl),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/asistencia');
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  String obtenerFechaHoraActual() {
  var ahora = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(ahora);
}

Future<void> enviarDatos(String codigo, String codigoCurso, String horaRegistro, bool asistio, String latitud, String longitud, String urlfoto) async {
  const url = 'http://3.22.217.187:80/api/v2/registrar_asistencia/'; // Reemplaza con la URL de tu API
  const token = '1da87ade3af5fecbfc5365487d29a0a82268fb71';
  final data = {
    'codigo_estudiante': codigo,
    'codigo_curso': codigoCurso,  
    'hora_registro': '2023-08-16T15:26:57.068175',
    'asistio': asistio,
    'latitud': latitud,
    'longitud': longitud,
    'urlfotoasistencia': urlfoto 
  };
  
  print(jsonEncode(data));
  final response = await http.post(
    Uri.parse(url),
    headers: {
       'Content-Type': 'application/json',
      'Authorization': 'Token $token'},
    body: jsonEncode(data),
  );


  if (response.statusCode == 200) {
    // Éxito: Puedes manejar la respuesta de la API si es necesario
    final responseData = json.decode(response.body);
    print('Respuesta de la API: $responseData');
  } else {
    // Manejo de errores
    print('Error en la solicitud: ${response.statusCode}');
  }
}

Future<void> cursosTotal() async {
  const  apiUrl = 'http://3.22.217.187:80/api/v2/cursos/';
  const  token = '1da87ade3af5fecbfc5365487d29a0a82268fb71';
  final headers = {
    'Authorization': 'Token $token',
  };

  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      print('Respuesta de la API: ${response.body}');
    } else {
      print('Respuesta de la API con error - status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error al obtener los datos de la API: $error');
  }
}

}