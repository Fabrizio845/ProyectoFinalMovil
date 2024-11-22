//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by fabrizio  calderon on 31/10/24.
//

import UIKit
import Network
import FirebaseAuth

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
                monitor.pathUpdateHandler = { path in
                    if path.status == .unsatisfied {
                        DispatchQueue.main.async {
                            self.mostrarAlerta(mensaje: "No hay conexión a Internet")
                        }
                    }
                }
                let queue = DispatchQueue(label: "Monitor")
                monitor.start(queue: queue)
    }

    @IBAction func IniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    mostrarAlerta(mensaje: "Por favor ingresa ambos campos")
                    return
                }

                guard email.contains("@"), password.count >= 6 else {
                    mostrarAlerta(mensaje: "Por favor, ingresa un correo válido y una contraseña de al menos 6 caracteres")
                    return
                }

                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.center = self.view.center
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()

                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()

                    if let error = error as NSError? {
                        switch error.code {
                        case AuthErrorCode.userNotFound.rawValue:
                            self.mostrarAlerta(mensaje: "Cuenta no creada")
                        case AuthErrorCode.wrongPassword.rawValue:
                            self.mostrarAlerta(mensaje: "Contraseña incorrecta")
                        case AuthErrorCode.invalidEmail.rawValue:
                            self.mostrarAlerta(mensaje: "El formato del correo es incorrecto")
                        default:
                            self.mostrarAlerta(mensaje: "Credenciales inválidas")
                        }
                        return
                    }

                    // Si el inicio de sesión es exitoso
                    self.mostrarAlerta(mensaje: "¡Bienvenido, \(authResult?.user.email ?? "Usuario")!") {
                        // Aquí redirigimos al siguiente ViewController después de que el usuario presione "OK"
                        self.performSegue(withIdentifier: "iniciarSesion", sender: self)
                    }
                }
        
    }
    
        func mostrarAlerta(mensaje: String, completion: (() -> Void)? = nil) {
            let alerta = UIAlertController(title: "Iniciar Sesión", message: mensaje, preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Ejecutamos el bloque de código que pasamos como parámetro cuando se presiona "OK"
                        completion?()
                    }))
                    self.present(alerta, animated: true, completion: nil)
        }
}
