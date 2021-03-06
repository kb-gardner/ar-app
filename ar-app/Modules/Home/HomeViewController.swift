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
        requestCollections(animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsCollection.register(R.nib.homeCollectionViewCell)
        spacesCollection.register(R.nib.homeCollectionViewCell)
        materialsCollection.register(R.nib.homeCollectionViewCell)
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
    
    func showProject(project: Project) {
        guard let controller = ProjectViewController.instantiate(project: project) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showMaterial(material: Material) {
        guard let controller = MaterialViewController.instantiate(material: material) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSpaceAR(space: Space) {}
    
    // MARK: - Requests
    func requestCollections(animated: Bool) {
        guard let id = Store.shared.user?.id else { return }
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        if animated { showHUD() }

        let projectsItem = DispatchWorkItem { [weak self] in
            group.enter()
            ProjectNetworkingService.listProjects(userId: id) { [weak self] projects, error in
                if let error = error {
                    print(error)
                } else {
                    self?.projects = projects ?? []
                }
                group.leave()
            }
        }
        queue.async(group: group, execute: projectsItem)
        
        let spacesItem = DispatchWorkItem { [weak self] in
            group.enter()
            SpaceNetworkingService.listSpaces(userId: id) { [weak self] spaces, error in
                if let error = error {
                    print(error)
                } else {
                    self?.spaces = spaces ?? []
                }
                group.leave()
            }
        }
        queue.async(group: group, execute: spacesItem)
        
        let materialsItem = DispatchWorkItem {
            group.enter()
            MaterialNetworkingService.listMaterials(userId: id) { [weak self] materials, error in
                if let error = error {
                    print(error)
                } else {
                    self?.materials = materials ?? []
                }
                group.leave()
            }
        }
        queue.async(group: group, execute: materialsItem)


        group.notify(queue: .main) { [weak self] in
            self?.projectsCollection.reloadData()
            self?.spacesCollection.reloadData()
            self?.materialsCollection.reloadData()
            self?.hideHUD()
        }
    }
    
}

// MARK: - Collections
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.homeCollectionViewCell, for: indexPath)!
        switch collectionView {
        case projectsCollection:
            let project = projects[indexPath.row]
            cell.setup(cellType: .project, imageUrl: project.imageUrl, title: project.name, subtitle: "\(spaces.filter({$0.projectId == project.id}).count) Spaces")
        case spacesCollection:
            let space = spaces[indexPath.row]
            cell.setup(cellType: .space, imageUrl: space.imageUrl, title: space.name, subtitle: projects.first(where: {$0.id == space.projectId})?.name)
        case materialsCollection:
            let material = materials[indexPath.row]
            cell.setup(cellType: .material, imageUrl: material.imageUrl, title: material.name, subtitle: material.isAvailableMessage)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.pulsate()
        switch collectionView {
        case projectsCollection:
            let project = projects[indexPath.row]
            showProject(project: project)
        case spacesCollection:
            let space = spaces[indexPath.row]
            showSpaceAR(space: space)
        case materialsCollection:
            let material = materials[indexPath.row]
            showMaterial(material: material)
        default:
            break
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
