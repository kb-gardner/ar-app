//
//  ProjectListViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class ProjectListViewController: UIViewController {
    // MARK: - Properties
    private var projects = [Project]()
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func addClicked(_ sender: Any) {
        // go to add project screen
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestProjects(animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.register(R.nib.projectTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension ProjectListViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    func requestProjects(animated: Bool) {
        guard let id = Store.shared.user?.id else { return }
        if animated { showHUD() }
        ProjectNetworkingService.listProjects(userId: id) { [weak self] projects, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.projects = projects ?? []
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table
extension ProjectListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.projectTableViewCell, for: indexPath)!
        cell.setup(imageUrl: project.imageUrl, name: project.name?.titlecased, address: project.address, priceEstimate: project.priceEstimate?.rounded(toPlaces: 2) ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.pulsate()
        let project = projects[indexPath.row]
        guard let controller = ProjectViewController.instantiate(project: project) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Properties
extension ProjectListViewController {
    class func instantiate() -> ProjectListViewController? {
        let controller = UIStoryboard(name: R.storyboard.projectListViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.projectListIdentifier()) as? ProjectListViewController
        return controller
    }
}
