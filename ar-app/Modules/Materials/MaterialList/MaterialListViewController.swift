//
//  MaterialListViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class MaterialListViewController: UIViewController {
    // MARK: - Properties
    private var materials = [Material]()
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func scanClicked(_ sender: Any) {
        // go to add material scan barcode screen
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMaterials(animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.register(R.nib.materialTableVIewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension MaterialListViewController {
    // MARK: - Navigation
    func showMaterial(material: Material) {
        guard let controller = MaterialViewController.instantiate(material: material) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestMaterials(animated: Bool) {
        guard let id = Store.shared.user?.id else { return }
        if animated { showHUD() }
        MaterialNetworkingService.listMaterials(userId: id) { [weak self] materials, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.materials = materials ?? []
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table
extension MaterialListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let material = materials[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.materialTableViewCell, for: indexPath)!
        cell .setup(imageUrl: material.imageUrl, name: material.name, price: material.bestPrice?.rounded(toPlaces: 2) ?? 0, amountType: material.amountType, storeName: material.storeName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.pulsate()
        let material = materials[indexPath.row]
        showMaterial(material: material)
    }
}

// MARK: - Properties
extension MaterialListViewController {
    class func instantiate() -> MaterialListViewController? {
        let controller = UIStoryboard(name: R.storyboard.materialListViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.materialListIdentifier()) as? MaterialListViewController
        return controller
    }
}
