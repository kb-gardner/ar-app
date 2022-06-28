//
//  TiersListViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/28/22.
//

import Foundation
import UIKit

class TiersListViewController: UIViewController {
    // MARK: - Properties
    private var tiers = [Tier]()
    private var selectedTier = Store.shared.user?.tierId?.int ?? 0
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(R.nib.tierTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        requestTiers()
    }
}

private extension TiersListViewController {
    // MARK: - Navigation
    func showSummary() {}
    func showSubScreen() {}
    
    // MARK: - Requests
    func requestTiers() {
        showHUD()
        TierNetworkingService.listTiers { [weak self] tiers, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.tiers = tiers ?? []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
}

extension TiersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tier = tiers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tierTableViewCell, for: indexPath)!
        cell.setup(title: tier.name, image: tier.image, price: tier.rate ?? 0, billingCycle: tier.billingCycle, summary: tier.summary, isRecommended: tier.isRecommended)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show either pop-up summary or apple subscription integration?
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.pulsate()
        showSummary()
        showSubScreen()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130
        }
        return 160
    }
}

// MARK: - Properties
extension TiersListViewController {
    class func instantiate() -> TiersListViewController? {
        let controller = UIStoryboard(name: R.storyboard.tiersListViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.tiersListIdentifier()) as? TiersListViewController
        return controller
    }
}
