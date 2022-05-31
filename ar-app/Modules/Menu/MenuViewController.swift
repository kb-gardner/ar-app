//
//  MenuViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/30/22.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func menuClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

private extension MenuViewController {
    // MARK: - Navigation
    func showHome() {
        guard let controller = HomeViewController.instantiate() else { return }
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showProjects() {
        guard let controller = HomeViewController.instantiate() else { return }
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAccount() {
        guard let controller = HomeViewController.instantiate() else { return }
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAbout() {
        guard let controller = HomeViewController.instantiate() else { return }
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Table
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    enum Options: String, CaseIterable {
        case home, projects, materials, account
        case about = "who we are"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.menuTableViewCell, for: indexPath)!
        cell.setup(image: UIImage(), title: Options.allCases[indexPath.row].rawValue.uppercased())
        return UITableViewCell()
    }
}

// MARK: - Properties
extension MenuViewController {
    class func instantiate() -> MenuViewController? {
        let controller = UIStoryboard(name: R.storyboard.menuViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.menuIdentifier()) as? MenuViewController
        return controller
    }
}
