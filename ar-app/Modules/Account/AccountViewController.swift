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
        editView.layer.cornerRadius = 25
        editView.applyDropShadow(x: -5, y: -5, blur: 10, color: UIColor.menuScanDropShadow.cgColor)
        tableView.register(R.nib.accountTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension AccountViewController {
    // MARK: - Navigation
    func showTierSelection() {
        guard let controller = TiersListViewController.instantiate() else { return }
        present(controller, animated: true)
    }
    
    func openEditView(_ field: AccountInfoRow, _ value: String?) {
        guard let controller = EditAccountViewController.instantiate(title: field.title, value: value, fieldType: field.type, onSave: { [weak self] newValue in
            switch field {
            case .name:
                self?.user?.name = newValue
            case .shippingAddress:
                self?.user?.address = newValue
            default:
                break
            }
            self?.saveUser()
        }) else { return }
        present(controller, animated: true)
    }
    
    func closeEditView() {
        editViewBottomConstraint.isActive = false
        editViewTopConstraint.isActive = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Requests
    func saveTier() {}
    
    func savePaymentInfo() {}
    
    func saveUser() {
        showHUD()
        UserNetworkingService.updateUser(user: user) { [weak self] newUser, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.user = newUser
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: - Table
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.setup(title: R.string.localizable.accountSubscriptionTitle().uppercased(), text: tiers.first(where: {$0.id == user?.tierId})?.name ?? R.string.localizable.tierFreeTitle(), buttonType: .upgrade, onSelect: { [weak self] in
                self?.showTierSelection()
            })
        case .name:
            cell.setup(title: R.string.localizable.accountAccountNameTitle().uppercased(), text: user?.name ?? R.string.localizable.none(), buttonType: .edit, onSelect: { [weak self] in
                self?.openEditView(.name, self?.user?.name)
            })
        case .shippingAddress:
            cell.setup(title: R.string.localizable.accountAddressTitle().uppercased(), text: user?.address ?? R.string.localizable.none(), buttonType: .edit, onSelect: { [weak self] in
                self?.openEditView(.shippingAddress, self?.user?.address)
            })
        case .logout:
            cell.setup(title: R.string.localizable.accountLogoutTitle().uppercased(), accountRow: .logout, onLogout: {
                AppRouter.shared.logout()
            })
        }
        return cell
    }
}

enum AccountInfoRow: Int, CaseIterable {
    case tierName, name, shippingAddress, logout
    
    var title: String {
        switch self {
        case .name:
            return R.string.localizable.editAccountNameTitle()
        case .shippingAddress:
            return R.string.localizable.editAccountAddressTitle()
        default:
            return "New Value"
        }
    }
    
    var type: UITextView.FieldType {
        switch self {
        case .name:
            return .name
        case .shippingAddress:
            return .address
        default:
            return .none
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
