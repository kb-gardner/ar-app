//
//  ProjectViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/1/22.
//

import Foundation
import UIKit
import Kingfisher

class ProjectViewController: UIViewController {
    // MARK: - Properties
    private var project: Project!
    private var spaces = [Space]()
    private var materials = [Material]()
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var projectImageCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scheduleButton: UIButton!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var spacesCollection: UICollectionView!
    @IBOutlet var materialsCollection: UICollectionView!
    @IBOutlet var buildSummaryButton: UIButton!
    @IBOutlet var orderButton: UIButton!
    
    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scheduleClicked(_ sender: Any) {
        // show edit view
    }
    
    @IBAction func editNoteClicked(_ sender: Any) {
        showNoteEdit()
    }
    
    @IBAction func spacesAddClicked(_ sender: Any) {
        // show add space
    }
    
    @IBAction func materialsAddClicked(_ sender: Any) {
        // show add material
    }
    
    @IBAction func buildSummaryClicked(_ sender: Any) {
        showBuildSummary()
    }
    
    @IBAction func orderClicked(_ sender: Any) {
        // show cart
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestSpaces()
        requestMaterials()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleButton.layer.cornerRadius = 8
        buildSummaryButton.layer.cornerRadius = 8
        orderButton.layer.cornerRadius = 8
        noteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNoteEdit)))
        spacesCollection.register(R.nib.projectSpaceCollectionViewCell)
        materialsCollection.register(R.nib.projectMaterialCollectionViewCell)
        projectImageCollection.register(R.nib.projectImageCollectionViewCell)
        spacesCollection.delegate = self
        spacesCollection.dataSource = self
        materialsCollection.delegate = self
        materialsCollection.dataSource = self
        projectImageCollection.delegate = self
        projectImageCollection.dataSource = self
        reloadData()
    }
}

private extension ProjectViewController {
    func reloadData() {
        nameLabel.text = project.name?.titlecased
        noteLabel.text = project.note
        pageControl.numberOfPages = project.imageUrls?.count ?? .zero
    }
    
    // MARK: - Navigation
    @objc func showNoteEdit() {
        guard let controller = EditAccountViewController.instantiate(title: "Note", value: project.note, fieldType: .none, isTextView: true, onSave: { [weak self] newValue in
            self?.project.note = newValue
            self?.updateProject()
        }) else { return }
        present(controller, animated: true)
    }
    
    func showBuildSummary() {
        guard let controller = BuildSummaryViewController.instantiate(project: project) else { return }
        present(controller, animated: true)
    }
    
    func showMaterialList() {
        
    }
    
    func showSpaceAR() {
        
    }
    
    func showImageCollection(imageUrl: String) {
        project.imageUrls?.removeAll(where: {$0 == imageUrl})
        project.imageUrls?.insert(imageUrl, at: 0)
        guard let urls = project.imageUrls, let controller = ImagesViewController.instantiate(imageUrls: urls) else { return }
        present(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestSpaces() {
        showHUD()
        SpaceNetworkingService.listSpaces(projectId: project.id) { [weak self] spaces, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.spaces = spaces ?? []
                    self?.spacesCollection.reloadData()
                }
            }
        }
    }
    
    func requestMaterials() {
        guard let id = project.id else { return }
        showHUD()
        MaterialNetworkingService.listMaterials(projectId: id) { [weak self] materials, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.materials = materials ?? []
                    self?.materialsCollection.reloadData()
                }
            }
        }
    }
    
    func updateProject() {
        showHUD()
        ProjectNetworkingService.updateProject(project: project) { [weak self] project, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.project = project
                    self?.reloadData()
                }
            }
        }
    }
}

// MARK: - Collections
extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case spacesCollection:
            return spaces.count
        case materialsCollection:
            return materials.count
        case projectImageCollection:
            return project.imageUrls?.count ?? .zero
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case spacesCollection:
            let space = spaces[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.projectSpaceCollectionViewCell, for: indexPath)!
            cell.setup(space: space)
            return cell
        case materialsCollection:
            let imageUrl = materials[indexPath.row].imageUrl
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.projectMaterialCollectionViewCell, for: indexPath)!
            cell.setup(imageUrl: imageUrl)
            return cell
        case projectImageCollection:
            let imageUrl = project.imageUrls?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.projectImageCollectionViewCell, for: indexPath)!
            cell.setup(imageUrl: imageUrl)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.pulsate()
        switch collectionView {
        case spacesCollection:
            let space = spaces[indexPath.row]
            // show space AR
        case materialsCollection:
            let material = materials[indexPath.row]
            guard let controller = MaterialViewController.instantiate(material: material) else { return }
            navigationController?.pushViewController(controller, animated: true)
        case projectImageCollection:
            guard let imageUrl = project.imageUrls?[indexPath.row] else { return }
            showImageCollection(imageUrl: imageUrl)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case spacesCollection:
            return CGSize(width: materialsCollection.frame.height, height: collectionView.frame.height)
        case materialsCollection:
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        case projectImageCollection:
            return CGSize(width: 300, height: 170)
        default:
            break
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case projectImageCollection:
            return .zero
        default:
            return 20
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

// MARK: - Properties
extension ProjectViewController {
    class func instantiate(project: Project) -> ProjectViewController? {
        let controller = UIStoryboard(name: R.storyboard.projectViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.projectIdentifier()) as? ProjectViewController
        controller?.project = project
        return controller
    }
}
