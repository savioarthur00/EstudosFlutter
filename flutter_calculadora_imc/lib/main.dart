import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weigthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String info_Text = "Informe seus dados";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  void _resetField() {
    weigthController.text = "";
    heightController.text = "";
    setState(() {
      info_Text = "Informe seus dados";
      _formKey = GlobalKey<FormState>();
    });

  }

  void _calculate(){
    setState(() {

      double weight =  double.parse(  weigthController.text);
      double height=  double.parse(  heightController.text) /100;

      double imc = weight / (height * height);

      if(imc<18.6){
        info_Text = "Abaixo do peso (${imc})";

      }else if(imc>=18.6 && imc< 24.9){
        info_Text = "Peso ideal(${imc.toStringAsPrecision(4)})";

      }
      else if(imc>=24.9 && imc< 29.9){
        info_Text = "Levemente acima do peso(${imc.toStringAsPrecision(4)})";

      }
      else if(imc>=29.9 && imc< 34.9){
        info_Text = "Obesidade grau 1 (${imc.toStringAsPrecision(4)})";

      }
      else if(imc>=34.9 && imc< 39.9){
        info_Text = "Obesidade grau 2 (${imc.toStringAsPrecision(4)})";

      }
      else if(imc>=40){
        info_Text = "Obesidade grau 3 (${imc.toStringAsPrecision(4)})";

      }



    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetField,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person_outline, size: 120.0, color: Colors.green),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso em kg",
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: weigthController,
                validator: (value){
                  if(value!.isEmpty){
                    return "Insira seu peso!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura em cm",
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: heightController,
                validator: (value){
                  if(value!.isEmpty){
                    return "Insira sua altura!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate() != null){
                        _calculate();
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1e8707),
                    ),
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Text(
                info_Text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
              ),
            ],
          ),
        )
      ),
    );
  }
}
