//
//  WelcomeViewController.swift
//  ArturCaiqueMarcosMarcioWendel
//
//  Created by Artur Clemente on 03/10/22.
//

import UIKit

final class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = .none
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let titleLabel = UILabel()
        titleLabel.text = "Bem-Vindo"
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }

    @IBAction func listToys(_ sender: Any) {
        if let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") {
            show(listTableViewController, sender: nil)
        }
    }
}
