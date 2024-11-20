//
//  RegistrarViewController.swift
//  ProyectoFinal
//
//  Created by fabrizio  calderon on 20/11/24.
//

import UIKit
import FirebaseAuth

class RegistrarViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty,
                      let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
                    showAlert(message: "Por favor, completa todos los campos.")
                    return
                }
                
                // Verificar si las contraseñas coinciden
                guard password == confirmPassword else {
                    showAlert(message: "Las contraseñas no coinciden.")
                    return
                }
                
                // Crear cuenta en Firebase
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.showAlert(message: "Error: \(error.localizedDescription)")
                        return
                    }
                    
                    // Cuenta creada con éxito
                    self.showAlert(message: "¡Cuenta creada con éxito!", completion: {
                        // Aquí puedes redirigir al usuario a otra pantalla
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
            
            // Función para mostrar alertas
            private func showAlert(message: String, completion: (() -> Void)? = nil) {
                let alert = UIAlertController(title: "Registro", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
