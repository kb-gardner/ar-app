//
//  SpaceARViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/30/22.
//

import Foundation
import UIKit

class SpaceARViewController: UIViewController {
    // MARK: - Properties
    private var onSave: ((Space)->())?
    private var project: Project!
    
    // MARK: - Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var scanBarcodeButton: UIButton!
    @IBOutlet var arButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var materialsButton: UIButton!
    @IBOutlet var groutButton: UIButton!
    
    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanClicked(_ sender: Any) {
        showScanBarcode()
    }
    
    @IBAction func arClicked(_ sender: Any) {
        startARScan()
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        showMenu()
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        showSearchView()
    }
    
    @IBAction func materialsClicked(_ sender: Any) {
        showMaterialsView()
    }
    
    @IBAction func groutClicked(_ sender: Any) {
        showGroutView()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension SpaceARViewController {
    func startARScan() {}
    
    func showMenu() {}
    
    func hideMenu() {}
    
    func showSearchView() {}
    
    func showMaterialsView() {}
    
    func showGroutView() {}
    
    // MARK: - Navigation
    func showScanBarcode() {}
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension SpaceARViewController {
    class func instantiate(project: Project, onSave: ((Space)->())?) -> SpaceARViewController? {
        let controller = UIStoryboard(name: R.storyboard.spaceARViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.spaceARIdentifier()) as? SpaceARViewController
        controller?.project = project
        controller?.onSave = onSave
        return controller
    }
}
