import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Endereco.dart';
import 'ConsultaCep.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Consulta CEP',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      home: const Home(
        title: 'Consultando CEPs',
      ),
    );
  }
}



class Home extends StatefulWidget {

  const Home({
    super.key,
    required this.title,
  });


  final String title;


  @override
  State<Home> createState() => _HomePageState();

}



class _HomePageState extends State<Home> {


  final TextEditingController cepController =
      TextEditingController();


  String cep = "";

  Endereco? endereco;

  String? erro;

  bool carregando = false;



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),

      ),


      body: Padding(

        padding: const EdgeInsets.all(8),

        child: ListView(

          children: [

            tffCep(),

            const SizedBox(height:16),


            btnConsultarCep(),


            const SizedBox(height:24),


            resultadoWidget(),

          ],
        ),
      ),
    );
  }




  TextFormField tffCep(){

    return TextFormField(

      controller: cepController,

      keyboardType: TextInputType.number,


      decoration: const InputDecoration(

        border: UnderlineInputBorder(),

        labelText: "CEP:",

        hintText: "00000-000",

      ),



      onChanged: (value){


        String numeros =
            value.replaceAll(RegExp(r'[^0-9]'), '');



        if(numeros.length > 8){

          numeros = numeros.substring(0,8);

        }



        String formatado = numeros;



        if(numeros.length > 5){

          formatado =
              '${numeros.substring(0,5)}-${numeros.substring(5)}';

        }



        if(formatado != value){

          cepController.value =
              TextEditingValue(

                text: formatado,

                selection:
                    TextSelection.collapsed(
                      offset: formatado.length,
                    ),

              );

        }

        setState(() {

          cep = formatado;

        });

      },

    );

  }

  ElevatedButton btnConsultarCep(){


    return ElevatedButton(


      style: ElevatedButton.styleFrom(

        backgroundColor: Colors.purple,

      ),



      onPressed: () async {



        String cepSemMascara =
            cep.replaceAll('-', '');



        if(cepSemMascara.length != 8){


          setState((){

            erro = "Digite um CEP válido.";

          });


          return;

        }

        setState((){


          carregando = true;

          endereco = null;

          erro = null;

        });

        try{


          Endereco data =
              await ConsultaCep.fetchCep(
                cepSemMascara,
              );


          setState((){

            endereco = data;

            carregando = false;


          });
        }catch(e){
          setState((){
            erro =
            "CEP não encontrado. Verifique e tente novamente.";

            carregando = false;

          });

        }

      },

      child: const Text(

        "Consultar",

        style: TextStyle(

          color: Colors.white,

          fontWeight: FontWeight.bold,

          fontSize:18,

        ),

      ),

    );

  }

  Widget resultadoWidget(){


    if(carregando){

      return const Center(

        child:CircularProgressIndicator(),

      );

    }

    if(erro != null){


      return Container(


        padding: const EdgeInsets.all(16),


        child: Text(

          erro!,

          style:
          const TextStyle(

            color: Colors.red,

            fontSize:16,

          ),

        ),

      );

    }
    if(endereco != null){
      final e = endereco!;
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children:[
            const Text(
              "Endereço encontrado",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:18,
              ),
            ),

            const Divider(),

            _linhaInfo(
              "CEP",
              e.cep,
            ),

            _linhaInfo(
              "Logradouro",
              e.logradouro,
            ),

            _linhaInfo(
              "Bairro",
              e.bairro,
            ),

            _linhaInfo(
              "Cidade",
              e.localidade,
            ),
            _linhaInfo(
              "Estado",
              e.uf,
            ),
          ],

        ),

      );

    }
    return const SizedBox.shrink();

  }

  Widget _linhaInfo(
      String label,
      String valor
      ){

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical:4,
      ),

      child: Text(
        "$label: $valor",
      ),
    );
  }


}