//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by fabrizio  calderon on 31/10/24.
//

import UIKit
import FirebaseAuth

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func IniciarSesionTapped(_ sender: Any) {
        // Obtén el correo y la contraseña de los textfields
                guard let email = emailTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    mostrarAlerta(mensaje: "Por favor ingresa ambos campos")
                    return
                }

                // Intentamos iniciar sesión con Firebase
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error as NSError? {
                        // Inspeccionar el código de error
                        switch error.code {
                        case AuthErrorCode.userNotFound.rawValue:
                            // El usuario no existe
                            self.mostrarAlerta(mensaje: "Cuenta no creada")
                        case AuthErrorCode.wrongPassword.rawValue:
                            // La contraseña es incorrecta
                            self.mostrarAlerta(mensaje: "Contraseña incorrecta")
                        case AuthErrorCode.invalidEmail.rawValue:
                            // El formato del correo no es válido
                            self.mostrarAlerta(mensaje: "El formato del correo es incorrecto")
                        default:
                            // Si el error no es uno de los anteriores
                            self.mostrarAlerta(mensaje: "Credenciales inválidas")
                        }
                        return
                    }

                    // Si no hubo error, mostramos el mensaje de éxito
                    self.mostrarAlerta(mensaje: "¡Bienvenido, \(authResult?.user.email ?? "Usuario")!")
                }
            }

            func mostrarAlerta(mensaje: String) {
                let alerta = UIAlertController(title: "Iniciar Sesión", message: mensaje, preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alerta, animated: true, completion: nil)
            }
        }
