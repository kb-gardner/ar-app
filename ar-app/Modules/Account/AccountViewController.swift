//
//  AccountViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
    // MARK: - Properties
    private var tiers = [Tier]()
    private var user = Store.shared.user
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editView: UIView!
    @IBOutlet var editViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var editViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.accountTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension AccountViewController {
    // MARK: - Navigation
    func showTierSelection() {}
    
    func openEditView(_ field: AccountInfoRow) {
        editViewBottomConstraint.isActive = true
        editViewTopConstraint.isActive = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func closeEditView() {
        editViewBottomConstraint.isActive = false
        editViewTopConstraint.isActive = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Requests
    func tiersRequest() {}
    
    func saveTier() {}
    
    func savePaymentInfo() {}
    
    func saveUser() {}
    
    func logout() {}
    
}

// MARK: - Table
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    enum AccountInfoRow: Int, CaseIterable {
        case tierName, name, shippingAddress, logout
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        AccountInfoRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountTableViewCell, for: indexPath)!
        switch AccountInfoRow.allCases[indexPath.section] {
        case .tierName:
            cell.setup(title: R.string.localizable.accountSubscriptionTitle().uppercased(), text: tiers.first(where: {$0.id == user?.tierId})?.name ?? R.string.localizable.tierFreeTitle(), buttonType: .upgrade) { [weak self] in
                self?.showTierSelection()
            }
        case .name:
            cell.setup(title: R.string.localizable.accountAccountNameTitle().uppercased(), text: user?.name ?? R.string.localizable.none(), buttonType: .edit) { [weak self] in
                self?.openEditView(.name)
            }
        case .shippingAddress:
            cell.setup(title: R.string.localizable.accountAddressTitle().uppercased(), text: user?.address ?? R.string.localizable.none(), buttonType: .edit) { [weak self] in
                self?.openEditView(.shippingAddress)
            }
        case .logout:
            cell.setup(title: R.string.localizable.accountLogoutTitle().uppercased())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch AccountInfoRow.allCases[indexPath.row] {
        case .logout:
            logout()
        default:
            break
        }
    }
}

// MARK: - Instantiation
extension AccountViewController {
    class func instantiate() -> AccountViewController? {
        let controller = UIStoryboard(name: R.storyboard.accountViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.accountIdentifier()) as? AccountViewController
        return controller
    }
}
