//
//  BuildSummaryViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/13/22.
//

import Foundation
import UIKit

class BuildSummaryViewController: UIViewController {
    // MARK: - Properties
    private var project: Project!
    
    // MARK: - Outlets
    @IBOutlet var wasteFactorLabel: UILabel!
    @IBOutlet var sqrFtLabel: UILabel!
    @IBOutlet var sqrFtView: UIView!
    @IBOutlet var updateButton: UIButton!
    
    // MARK: - Actions
    @IBAction func updateClicked(_ sender: Any) {
        updateProject()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        sqrFtView.layer.cornerRadius = 8
        sqrFtView.layer.borderWidth = 2
        sqrFtView.layer.borderColor = UIColor.menuImageGray.cgColor
        updateButton.layer.cornerRadius = 8
    }
}

private extension BuildSummaryViewController {
    func reloadData() {
        wasteFactorLabel.text = "\(project.wasteFactorPercent ?? 0) %"
        sqrFtLabel.text = "\(project.areaSqrFt ?? 0) SQ FT"
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
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

// MARK: - Properties
extension BuildSummaryViewController {
    class func instantiate(project: Project) -> BuildSummaryViewController? {
        let controller = UIStoryboard(name: R.storyboard.buildSummaryViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.buildSummaryIdentifier()) as? BuildSummaryViewController
        controller?.project = project
        return controller
    }
}
