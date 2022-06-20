//
//  AddProjectViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/30/22.
//

import Foundation
import UIKit

class AddProjectViewController: UIViewController {
    // MARK: - Properties
    private var onClose: (()->())?
    private var name: String?
    private var address: String?
    
    // MARK: - Outlets
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var nameView: LineTextView!
    @IBOutlet var addressView: LineTextView!
    @IBOutlet var startScanningButton: UIButton!
    
    // MARK: - Actions
    @IBAction func closeClicked(_ sender: Any) {
        onClose?()
    }
    
    @IBAction func startScanningClicked(_ sender: Any) {
        saveProject()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.setup(title: "Project Name", value: nil, fieldType: .name) { [weak self] text in
            self?.name = text
        }
        addressView.setup(title: "Address", value: nil, fieldType: .address) { [weak self] text in
            self?.address = text
        }
    }
}

private extension AddProjectViewController {
    // MARK: - Navigation
    func showSpaceAR(project: Project) {
        guard let controller = SpaceARViewController.instantiate(project: project, onSave: { [weak self] space in
            self?.showProject()
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showProject() {}
    
    // MARK: - Requests
    func saveProject() {
        guard let id = Store.shared.user?.id else { return }
        let project = Project(name: name, address: address, userId: id)
        showHUD()
        ProjectNetworkingService.createProject(project: project) { [weak self] newProject, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    if let newProject = newProject {
                        self?.showSpaceAR(project: newProject)
                    }
                }
            }
        }
    }
}

// MARK: - Properties
extension AddProjectViewController {
    class func instantiate(onClose: (()->())?) -> AddProjectViewController? {
        let controller = UIStoryboard(name: R.storyboard.addProjectViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.addProjectIdentifier()) as? AddProjectViewController
        controller?.onClose = onClose
        return controller
    }
}
