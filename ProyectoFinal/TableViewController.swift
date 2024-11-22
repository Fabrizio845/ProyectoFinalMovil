import UIKit

class TableViewController: UITableViewController {

    // Arreglo para almacenar las reuniones
    var reuniones: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura el botón + en la barra de navegación
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregarReunion))
    }

    // Este método es para manejar el botón + y realizar el segue al AgregarReunionViewController
    @objc func agregarReunion() {
        performSegue(withIdentifier: "showAgregarReunion", sender: nil)
    }

    // MARK: - Table view data source

    // Retorna 1 sección
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Retorna el número de filas igual al número de reuniones en el arreglo
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reuniones.count
    }

    // Configura las celdas de la tabla con los datos de las reuniones
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = reuniones[indexPath.row]
        return cell
    }

    // Este método se ejecuta cuando el usuario hace un segue al AgregarReunionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAgregarReunion" {
            if let destinoVC = segue.destination as? AgregarReunionViewController {
                destinoVC.reuniones = self.reuniones // Pasar el arreglo de reuniones al siguiente ViewController
            }
        }
    }

    // Este método permite actualizar la tabla cuando se agrega una nueva reunión
    func actualizarTabla() {
        self.tableView.reloadData()
    }
}
