//
//  HomeViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    private var projects = [Project]()
    private var spaces = [Space]()
    private var materials = [Material]()
    
    // MARK: - Outlets
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var addProjectButton: UIButton!
    @IBOutlet var projectsCollection: UICollectionView!
    @IBOutlet var spacesCollection: UICollectionView!
    @IBOutlet var materialsCollection: UICollectionView!
    @IBOutlet var newProjectView: UIView!
    @IBOutlet var newProjectViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var newProjectViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func menuClicked(_ sedner: Any) {
        showMenu()
    }
    
    @IBAction func addProjectClicked(_ sedner: Any) {
        showNewProjectView()
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestProjects()
        requestSpaces()
        requestMaterials()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsCollection.delegate = self
        projectsCollection.dataSource = self
        materialsCollection.delegate = self
        materialsCollection.dataSource = self
        spacesCollection.delegate = self
        spacesCollection.dataSource = self
    }
}

private extension HomeViewController {
    // MARK: - Navigation
    func showMenu() {
        guard let controller = MenuViewController.instantiate() else { return }
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }
    
    func showNewProjectView() {}
    
    // MARK: - Requests
    func requestProjects() {
        guard let id = Store.shared.user?.id else { return }
        ProjectNetworkingService.getProjects()
    }
    
    func requestSpaces() {
        guard let id = Store.shared.user?.id else { return }
        SpaceNetworkingService.getSpaces()
    }
    
    func requestMaterials() {
        guard let id = Store.shared.user?.id else { return }
        MaterialNetworkingService.getMaterials()
    }
    
}

// MARK: - Collections
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case projectsCollection:
            return projects.count
        case spacesCollection:
            return spaces.count
        case materialsCollection:
            return materials.count
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case projectsCollection:
            return UICollectionViewCell()
        case spacesCollection:
            return UICollectionViewCell()
        case materialsCollection:
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    
}


// MARK: - Properties
extension HomeViewController {
    class func instantiate() -> HomeViewController? {
        let controller = UIStoryboard(name: R.storyboard.homeViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.homeIdentifier()) as? HomeViewController
        return controller
    }
}
