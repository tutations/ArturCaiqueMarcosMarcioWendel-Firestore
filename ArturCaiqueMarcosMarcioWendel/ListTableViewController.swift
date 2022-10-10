//
//  ListTableViewController.swift
//  ArturCaiqueMarcosMarcioWendel
//
//  Created by Artur Clemente on 03/10/22.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {

    // MARK: - Properties
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sem brinquedos cadastrados"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        return label
    }()
    private let collection = "toysList"
    private var toysList: [ToyItem] = []
    private lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var firestoreListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToysList()
    }
    
    private func loadToysList() {
        firestoreListener = firestore
            .collection(collection)
            .order(by: "name", descending: false)
            .addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    guard let snapshot = snapshot else { return }
                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                        self.showItemsFrom(snapshot: snapshot)
                    }
                }
            })
    }
    
    private func showItemsFrom(snapshot: QuerySnapshot) {
        toysList.removeAll()
        for document in snapshot.documents {
            let id = document.documentID
            let data = document.data()
            let name = data["name"] as? String ?? "---"
            let telephone = data["telephone"] as? String ?? "---"
            let toyItem = ToyItem(id: id, name: name, telephone: telephone)
            toysList.append(toyItem)
        }
        tableView.reloadData()
    }
    
    private func showAlertForItem(_ item: ToyItem?) {
        let alert = UIAlertController(
            title: "Brinquedo",
            message: "Entre com as informações do brinquedo abaixo",
            preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome"
            textField.text = item?.name
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 78, width: 270, height:18))
        label.textAlignment = .center
        label.textColor = .red
        label.font = label.font.withSize(12)
        alert.view.addSubview(label)
        label.isHidden = true
        
        alert.addTextField { textField in
            textField.placeholder = "Telefone"
            textField.keyboardType = .numberPad
            textField.text = item?.telephone
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let name = alert.textFields?.first?.text,
                  let telephone = alert.textFields?.last?.text else {return}
            
            if name == "" {
                label.text = "Informe o nome do brinquedo."
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            }
            else if telephone == "" {
                label.text = "Informe o telefone."
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                let data: [String: Any] = [
                    "name": name,
                    "telephone": telephone
                ]
                
                if let item = item {
                    // Edição
                    self.firestore
                        .collection(self.collection)
                        .document(item.id)
                        .updateData(data) { error in
                            if let error = error {
                                print(error)
                            }
                        }
                } else {
                    // Criação
                    self.firestore
                        .collection(self.collection)
                        .addDocument(data: data) { error in
                            if let error = error {
                                print(error)
                            }
                        }
                }
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancelar",
            style: .cancel,
            handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert,
                animated: true,
                completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = toysList.count
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RowTableViewCell else {
            return UITableViewCell()
        }

        let toyItem = toysList[indexPath.row]
        cell.configure(with: toyItem)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toyItem = toysList[indexPath.row]
        showAlertForItem(toyItem)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toyItem = toysList[indexPath.row]
            firestore.collection(collection)
                .document(toyItem.id)
                .delete()
        }
    }

    @IBAction func addItem(_ sender: Any) {
        showAlertForItem(nil)
    }
}
