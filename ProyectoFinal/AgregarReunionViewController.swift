//
//  AgregarReunionViewController.swift
//  ProyectoFinal
//
//  Created by fabrizio calderon on 20/11/24.
//

import UIKit
import AVFoundation

class AgregarReunionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioFilename: URL?

    @IBOutlet weak var nombreReunionTextField: UITextField!
    @IBOutlet weak var imagenReferencialImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var microfonoButton: UIButton!

    @IBAction func microfonoButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording(sender: sender)
        } else {
            finishRecording(success: true, sender: sender)
        }
    }

    @IBAction func reproducirButtonTapped(_ sender: Any) {
        guard let audioFilename = audioFilename else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
        } catch {
            print("Error al reproducir el audio: \(error.localizedDescription)")
        }
    }

    @IBAction func elegirUbicacionButtonTapped(_ sender: Any) {
        // Navegar a la vista de ElegirUbicacionViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let elegirUbicacionVC = storyboard.instantiateViewController(identifier: "ElegirUbicacionViewController") as? ElegirUbicacionViewController {
            self.navigationController?.pushViewController(elegirUbicacionVC, animated: true)
        }
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func guardarReunionButtonTapped(_ sender: Any) {
        // Guardar la reunión
        let nombreReunion = nombreReunionTextField.text ?? ""
        let fechaReunion = datePicker.date
        let imagenReferencial = imagenReferencialImageView.image

        // Guardar los datos (por ejemplo, en UserDefaults para simplicidad)
        let userDefaults = UserDefaults.standard
        userDefaults.set(nombreReunion, forKey: "nombreReunion")
        userDefaults.set(fechaReunion, forKey: "fechaReunion")
        // Convertir imagen a datos y guardar
        if let imagenData = imagenReferencial?.jpegData(compressionQuality: 1.0) {
            userDefaults.set(imagenData, forKey: "imagenReferencial")
        }
        // Mostrar mensaje de guardado
        let alert = UIAlertController(title: "Reunión Guardada", message: "La reunión ha sido guardada exitosamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Audio Recording
    func startRecording(sender: UIButton) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            // Cambiar el título del botón a "Detener"
            sender.setTitle("Detener", for: .normal)
        } catch {
            finishRecording(success: false, sender: sender)
        }
    }

    func finishRecording(success: Bool, sender: UIButton) {
        audioRecorder?.stop()
        audioRecorder = nil

        // Cambiar el título del botón a "Grabar"
        sender.setTitle("Grabar", for: .normal)

        if success {
            print("Grabación exitosa")
        } else {
            print("Error al grabar")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagenReferencialImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false, sender: microfonoButton)
        }
    }
}

