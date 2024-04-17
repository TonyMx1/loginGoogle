import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '412962165343-og5vhgeg5rickk8u2725elf7u4akdkar.apps.googleusercontent.com',
);
final FacebookAuth _facebookAuth = FacebookAuth.instance;

Future<void> registerWithEmailAndPassword(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('La contraseña es demasiado débil.');
    } else if (e.code == 'email-already-in-use') {
      print('El correo electrónico ya está en uso.');
    }
  } catch (e) {
    print('Error al registrar el usuario: $e');
  }
}

Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('Usuario no encontrado para ese correo electrónico.');
    } else if (e.code == 'wrong-password') {
      print('Contraseña incorrecta proporcionada para ese usuario.');
    }
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } catch (e) {
    print('Error al iniciar sesión con Google: $e');
  }
}

Future<void> signInWithFacebook(BuildContext context) async {
  try {
    final LoginResult result = await _facebookAuth.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } catch (e) {
    print('Error al iniciar sesión con Facebook: $e');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Bienvenido!'),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Fondo(),
          Contenido(),
        ],
      ),
    );
  }
}

class Fondo extends StatelessWidget {
  const Fondo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.blue.shade300,
            Colors.blue,
          ],
        ),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({Key? key}) : super(key: key);

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: 5),
          Text(
            'Bienvenido',
            style: TextStyle(
                color: Colors.white, fontSize: 18, letterSpacing: 1.5),
          ),
          SizedBox(height: 15),
          Datos(),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class Datos extends StatefulWidget {
  const Datos({Key? key}) : super(key: key);

  @override
  State<Datos> createState() => _DatosState();
}

class _DatosState extends State<Datos> {
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'micorreo@micorreo.com'),
          ),
          const SizedBox(height: 5),
          const Text(
            'Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            obscureText: showPass,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'contraseña',
                suffixIcon: IconButton(
                  icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => {
                    setState(() {
                      showPass = !showPass;
                    })
                  },
                )),
          ),
          const Remember(),
          const SizedBox(height: 30),
          const Botones(),
        ],
      ),
    );
  }
}

class Remember extends StatefulWidget {
  const Remember({Key? key}) : super(key: key);

  @override
  State<Remember> createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (value) {
            setState(() => checked == false ? checked = true : checked = false);
          },
        ),
        const Text(
          "Recordar cuenta",
          style: TextStyle(fontSize: 12),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecordarPassword()));
          },
          child: const Text(
            "¿Olvidaste tu contraseña?",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class Botones extends StatelessWidget {
  const Botones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              signInWithEmailAndPassword(
                  _emailController.text, _passwordController.text, context);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff142047))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              registerWithEmailAndPassword(
                  _emailController.text, _passwordController.text);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff142047))),
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        const Text(
          'O entra con',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              signInWithGoogle(context);
            },
            child: const Text(
              'Google',
              style: TextStyle(
                color: Color(0xff142047),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              signInWithFacebook(context);
            },
            child: const Text(
              'Facebook',
              style: TextStyle(
                color: Color(0xff142047),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Politicas de privacidad",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class RecordarPassword extends StatelessWidget {
  const RecordarPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordar Contraseña'),
      ),
      body: const Center(
        child: Text('Página de recordar contraseña'),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
