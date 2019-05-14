//
//  ViewController.swift
//  alumnos
//
//  Created by LABMAC07 on 02/05/19.
//  Copyright © 2019 kast. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var refAlumnos: DatabaseReference!
    //static var isLaunched = false
    
    
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textCalificacion: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tableViewAlumnos: UITableView!

    var alumnoList = [AlumnoModel]()
    

    @IBAction func buttonAddAlumnos(_ sender: UIButton) {
        addAlumno()
        textNombre.text! = ""
        textCalificacion.text! = ""
    }
    func addAlumno(){
        let key = refAlumnos.childByAutoId().key
        let alumno = ["id":key,
                      "alumnoNombre": textNombre.text! as String,
                      "alumnoCalificacion": textCalificacion.text! as String
                        ]
        refAlumnos.child(key!).setValue(alumno)
        labelMessage.text = "Alumno Añadido"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // if !ViewController.isLaunched{
            FirebaseApp.configure()
           // ViewController.isLaunched = true
        
        refAlumnos = Database.database().reference().child("alumnos");
        refAlumnos.observe(DataEventType.value, with: { (snapshot) in

            if snapshot.childrenCount > 0 {

                self.alumnoList.removeAll()

                for alumnos in snapshot.children.allObjects as! [DataSnapshot] {
                    let alumnoObject = alumnos.value as? [String: AnyObject]
                    let alumnoNombre  = alumnoObject?["alumnoNombre"]
                    let alumnoId  = alumnoObject?["id"]
                    let alumnoCalificacion = alumnoObject?["alumnoCalificacion"]

                    let alumno = AlumnoModel(id: alumnoId as! String?, nombre: alumnoNombre as! String?, calificacion: alumnoCalificacion as! String?)

                    self.alumnoList.append(alumno)
                }
                self.tableViewAlumnos.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let alumno  = alumnoList[indexPath.row]

        let alertController = UIAlertController(title: alumno.nombre, message: "dame valores para actualizar", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Actualizar", style: .default) { (_) in

            let id = alumno.id
            let nombre = alertController.textFields?[0].text
            let calificacion = alertController.textFields?[1].text

            self.updateAlumno(id: id!, nombre: nombre!, calificacion: calificacion!)
        }
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deleteAlumno(id: alumno.id!)
        }
        alertController.addTextField{(textField) in
        textField.text = alumno.nombre
        }
        alertController.addTextField { (textField) in
            textField.text = alumno.calificacion
        }
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)

        present(alertController, animated: true, completion: nil)
    }
    func updateAlumno(id:String, nombre:String, calificacion:String){
        let alumno = ["id":id,
                      "alumnoNombre": nombre,
                      "alumnoCalificacion": calificacion
        ]
        refAlumnos.child(id).setValue(alumno)
        labelMessage.text = "Alumno Actualizado"
    }
    
    func deleteAlumno(id:String){
        refAlumnos.child(id).setValue(nil)
        labelMessage.text = "Alumno Eliminado"
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return alumnoList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        let alumno: AlumnoModel
        alumno = alumnoList[indexPath.row]
        cell.labelNombre.text = alumno.nombre
        cell.labelCalificacion.text = alumno.calificacion
        return cell
    }

}

