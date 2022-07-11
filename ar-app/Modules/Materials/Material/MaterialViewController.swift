//
//  MaterialViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/1/22.
//

import Foundation
import UIKit
import Kingfisher

class MaterialViewController: UIViewController {
    // MARK: - Properties
    private var material: Material!
    private var similarMaterials = [Material]()
    private var materialOptions = [Material]()
    
    // MARK: - Outlets
    @IBOutlet var scrollContentView: UIView!
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var materialImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountTypeLabel: UILabel!
    @IBOutlet var colorSizeLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var optionsCollection: UICollectionView!
    @IBOutlet var similarCollection: UICollectionView!
    
    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        material.isFavorite?.toggle()
        favoriteButton.setImage(material.isFavorite == true ? R.image.favoriteSelectedLarge() : R.image.favoriteNotSelectedLarge(), for: .normal)
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMaterialOptions()
        requestSimilarMaterials()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsCollection.register(R.nib.materialCollectionViewCell)
        similarCollection.register(R.nib.materialCollectionViewCell)
        optionsCollection.delegate = self
        optionsCollection.dataSource = self
        similarCollection.delegate = self
        similarCollection.dataSource = self
        materialImageView.layer.cornerRadius = 15
        reloadData()
    }
}

private extension MaterialViewController {
    func reloadData() {
        if let stringUrl = material.imageUrl, let url = URL(string: stringUrl) {
            materialImageView.kf.setImage(with: url)
        }
        nameLabel.text = material.name
        priceLabel.text = "$\(material.bestPrice?.rounded(toPlaces: 2) ?? 0.00)"
        amountTypeLabel.text = "/\(material.amountType ?? "No Grouping Specified")"
        colorSizeLabel.text = "\(material.color?.titlecased ?? "No Color Specified") - \(material.width?.rounded(toPlaces: 2) ?? 0)\(material.measurementType ?? "") x \(material.height?.rounded(toPlaces: 2) ?? 0)\(material.measurementType ?? "")"
        summaryLabel.text = material.summary
        favoriteButton.setImage(material.isFavorite == true ? R.image.favoriteSelectedLarge() : R.image.favoriteNotSelectedLarge(), for: .normal)
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    func requestSimilarMaterials() {
        showHUD()
        MaterialNetworkingService.listMaterials(color: material.color) { [weak self] materials, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.similarMaterials = materials ?? []
                    self?.similarCollection.reloadData()
                }
            }
        }
    }
    
    func requestMaterialOptions() {
        showHUD()
        MaterialNetworkingService.listMaterials(name: material.name) { [weak self] materials, error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    print(error)
                } else {
                    self?.materialOptions = materials ?? []
                    self?.optionsCollection.reloadData()
                }
            }
        }
    }
}

// MARK: - Collections
extension MaterialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case optionsCollection:
            return materialOptions.count
        case similarCollection:
            return similarMaterials.count
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.materialCollectionViewCell, for: indexPath)!
        switch collectionView {
        case optionsCollection:
            let material = materialOptions[indexPath.row]
            cell.setup(imageUrl: material.imageUrl, storeName: material.storeName, price: material.bestPrice?.rounded(toPlaces: 2) ?? 0, amountType: material.amountType) { [weak self] in
                // add to cart
            }
            return cell
        case similarCollection:
            let material = similarMaterials[indexPath.row]
            cell.setup(imageUrl: material.imageUrl, storeName: material.storeName, price: material.bestPrice?.rounded(toPlaces: 2) ?? 0, amountType: material.amountType) { [weak self] in
                // add to cart
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case optionsCollection:
            let material = materialOptions[indexPath.row]
            self.material = material
            reloadData()
        case similarCollection:
            let material = similarMaterials[indexPath.row]
            self.material = material
            reloadData()
        default:
            break
        }
        requestMaterialOptions()
        requestSimilarMaterials()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}

// MARK: - Properties
extension MaterialViewController {
    class func instantiate(material: Material) -> MaterialViewController? {
        let controller = UIStoryboard(name: R.storyboard.materialViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.materialIdentifier()) as? MaterialViewController
        controller?.material = material
        return controller
    }
}
