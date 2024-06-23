// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;


class ProcesoAsistencia extends StatefulWidget {
  const ProcesoAsistencia({super.key});

  @override
  State<ProcesoAsistencia> createState() => _ProcesoAsistenciaState();
}

class _ProcesoAsistenciaState extends State<ProcesoAsistencia> {
  // Coordenadas del lugar específico que deseas verificar
  final double targetLatitude = -12.052130794030704; // Latitud del lugar específico FIEI
  final double targetLongitude = -77.043833850632; // Longitud del lugar específico FIEI
  //final double targetLatitude = -11.9660592; // Latitud del lugar específico CASA
  //final double targetLongitude = -76.9819809; // Longitud del lugar específico CASA

  // Estado para almacenar la ubicación actual
  Position? currentPosition;
  String? currentAddress;

  //variable Codigo
  final TextEditingController codigoController = TextEditingController();
  String codigoIngresado = '';
  File? fotoSubir;
  bool isButtonEnabled = false;
  List<String> cursos = ['Proyecto Integrador','Teleinformafica','Investigacion Operativa'];
  List<dynamic> cursos1 = [];
  Map<String, String> listaNombres = {
    '2019015456': 'Cesar Hinostroza Turin',
    '2018008947': 'Alvaro Guzman Castaños',
    '2018011723': 'Arnold Joel Mandamiento Ninaja',
    '2018028413': 'Uddhava Fernando Gabriel Canepa Zegarra',
    '2018024826': 'Neil Titow Angles Payano'};
   @override
   void dispose() {
    codigoController.dispose();
    super.dispose();
  }
  void updateButtonActivation() {
    setState(() {
      isButtonEnabled = codigoController.text.length == 10;
    });
  }
  @override
  void initState() {
    super.initState();
    iniciarProcesoVerficacion();
  }
  Future<void> iniciarProcesoVerficacion() async {
    await solicitarPermisos();
    await obtenerUbicacionActual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                
              const SizedBox(height: 30),
              
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Codigo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),    
              ),),

              const SizedBox(height: 10,),
              
              TextField(
                  controller: codigoController,
                  keyboardType: TextInputType.number,
                  onChanged: (text){
                    setState(() {
                      updateButtonActivation();
                      codigoIngresado = codigoController.text;
                    });
                  },
                  maxLength: 10,
                  decoration:  InputDecoration(
                    hintText: 'Ingresar Codigo ',
                    filled: true,
                    fillColor: Colors.white,
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
      
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Cordenadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),    
              ),),

              const SizedBox(height: 10,),
              
              Container(
                padding: const EdgeInsets.all(20),
                //width: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                color:  Colors.orangeAccent,
                width: 2,
                  ),
                ),
                child:currentPosition == null
              ? const CircularProgressIndicator(): Column(
              children: [
                Text('Latitud: ${currentPosition!.latitude}'),
                const SizedBox(height: 5),
                Text('Longitud: ${currentPosition!.longitude}'),
                const SizedBox(height: 5),
                currentAddress == null
                ? const Text('Cargando dirección...')
                : Text(
                    'Ubicación: $currentAddress',
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 5),
                Text(
                  isInSpecificLocation()
                  ? '¡Estás en el lugar específico!'
                  : 'No estás en el lugar específico.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isInSpecificLocation() ? Colors.blue : Colors.red,
                    ),
                  ),
                ],
              ),
              ),
              
            const SizedBox(height: 20), 

            Center(
              child: fotoSubir != null?
                Image.file(
                  fotoSubir!,
                  width: 200,
                  height: 200,
                  )
                :ElevatedButton(
                  onPressed: !isButtonEnabled? ()async{
                    showSnackbar('El codigo debe de contener 10 numeros');
                  } : () async{
                 
                  //Navigator.pushNamed(context, '/procesoasistencia');
                  final foto = await getFoto();
                  if(foto == null) {
                    return;
                  }
                  setState(() {
                    fotoSubir = File(foto.path);
                  });

                  showProcessingDialog(context);
                  //final imageUrl = await uploadImageAndGetUrl(fotoSubir!);
                  await verificacionRostro2(fotoSubir!,fotoSubir!);
                },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    fixedSize: const Size(200, 200),
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Image(
                        height: 100,
                        image: AssetImage('assets/selfies.png')), 
                        SizedBox(height: 10,),
                        Text(
                          'tomar selfie',
                          style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold, 
                          color: Colors.black),
                          ),
                    ]),)),  
                ],
                )
              ),),),
            );
      }
  Future<void> solicitarPermisos() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      obtenerUbicacionActual();
    } else {
      return;
    }
  }

  Future<void> obtenerUbicacionActual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
      // ignore: unnecessary_null_comparison
      if (position != null) {
        // Actualizar el estado para mostrar la ubicación actual en pantalla
        setState(() {
          currentPosition = position;
        });

        // Llamar al método para obtener la dirección
        await getCurrentAddress();

      }else {
        setState(() {
          currentAddress = 'No se pudo obtener la ubicación';
        });
      }

    } catch (e) {
      setState(() {
        print(e.toString());
      });
    }
  }

  Future<void> getCurrentAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
         Placemark placemark = placemarks[0];
         String address = '${placemark.street ?? ''}, ${placemark.subLocality ?? ''},';
      address += ' ${placemark.locality ?? ''}, ${placemark.country ?? ''}';
        setState(() {
          currentAddress = address;
        });
        //print(currentAddress);
      } else {
        setState(() {
          currentAddress = 'Dirección desconocida';
        });
      }
    } catch (e) {
      // Manejo de errores
      print(e.toString());
      setState(() {
        currentAddress = 'Error al obtener la dirección';
      });
    }
  }

  // Método para verificar si te encuentras en el lugar específico
  bool isInSpecificLocation() {
    if (currentPosition != null) {
      // Calcular la distancia entre la ubicación actual y el lugar específico
      double distance = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        targetLatitude,
        targetLongitude,
      );

      // Definir un umbral para considerar que estás en el lugar específico (en metros)
      double threshold = 100.0; // Por ejemplo, 100 metros

      // Verificar si estás en el lugar específico
      return distance <= threshold;
    }
    return false;
  }

  Future<XFile?> getFoto() async {
  final ImagePicker picker = ImagePicker();
  final XFile? fotoFile = await picker.pickImage(source: ImageSource.camera);

  if (fotoFile != null) {
    final bytes = File(fotoFile.path).readAsBytesSync();
    img.Image? imagen = img.decodeImage(bytes);
    
    // Redimensiona la imagen a un ancho de 600 (manteniendo la relación de aspecto)
    final img.Image resized = img.copyResize(imagen!, width: 600);

    // Guarda la imagen redimensionada en el archivo original
    File(fotoFile.path).writeAsBytesSync(img.encodeJpg(resized));

    return fotoFile;
  } else {
    return null;
    }
}

Future<void> verificacionRostro2(File foto, File image) async {
    
  const url = 'http://3.22.217.187:80/api/v2/uploadimage/';
  const token = '1da87ade3af5fecbfc5365487d29a0a82268fb71'; 
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
                'Authorization': 'Token $token'},
      body: {
        'codigo': codigoIngresado,
        'image': base64Encode(await foto.readAsBytes()),
      },
    );
    print("base ${base64Encode(await foto.readAsBytes())}");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('responseData $responseData');
      final isPersonCorrect = responseData['status'];
      //print('Respuesta de la API: $responseData');
      if(isPersonCorrect.toString() != '0'){
        final urlCursos = Uri.parse('http://3.22.217.187:80/api/v2/cursos-estudiante/$codigoIngresado/');
        //no estoy enviando datos(formato) en el curpo de la solicitud. por ende no es necesario
        //incluir el encabezado contentype app/json
        final responseCursos = await http.get(urlCursos,
        headers: {'Authorization': 'Token $token'});

        if (responseCursos.statusCode == 200) {
          final responseDataCursos = jsonDecode(responseCursos.body);
          print('responseCurso: $responseDataCursos');
          
          cursos1 = responseDataCursos;
             // Accede al elemento en la posición i
          final urlNombre = Uri.parse('http://3.22.217.187:80/api/v2/estudiante/$codigoIngresado/');
          final responseNombre = await http.get(urlNombre,
          headers: {'Authorization': 'Token $token'});
          if(responseNombre.statusCode == 200){
            final data = jsonDecode(responseNombre.body);
            final nombre = data['name'];
            print("Nombre del estudiante: ${nombre.toString()}");
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushNamed(
            context,
            '/finalizarasistencia',
            arguments: {
              'codigo': codigoIngresado,
              'nombre': nombre.toString(),
              'cursos': cursos1,
              'token': token,
              'coordenada x': currentPosition!.latitude.toString(),
              'coordenada y': currentPosition!.longitude.toString(),
              'image': image,
            },
          );
          }else{
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushNamed(context, '/errorasistencia');
            print('Error en la solicitud1: ${response.statusCode}');
          }

        }else{
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushNamed(context, '/errorasistencia');
          print('Error en la solicitud1: ${response.statusCode}');
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushNamed(context, '/errorasistencia');
      }
    }else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushNamed(context, '/errorasistencia');
      print('Error en la solicitud2: ${response.statusCode}');
    }
    }catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushNamed(context, '/errorasistencia');
    print('Error en la solicitud3: $e');
  }
}


Future<void> showProcessingDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Procesando Captura'),
        content: Text('Espere un momento...'),
      );
    },
  );
}

void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
