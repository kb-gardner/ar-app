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
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsCollection.register(R.nib.materialCollectionViewCell)
        similarCollection.register(R.nib.materialCollectionViewCell)
        optionsCollection.delegate = self
        optionsCollection.dataSource = self
        similarCollection.delegate = self
        similarCollection.dataSource = self
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
        amountTypeLabel.text = material.amountType
        colorSizeLabel.text = "\(material.color ?? "No Color Specified") - \(material.width ?? 0)\(material.measurementType ?? "") x \(material.height ?? 0)\(material.measurementType ?? "")"
        summaryLabel.text = material.summary
        favoriteButton.setImage(material.isFavorite == true ? R.image.favoriteSelectedLarge() : R.image.favoriteNotSelectedLarge(), for: .normal)
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    func requestSimilarMaterials() {
        
    }
    
    func requestMaterialOptions() {
        
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
            return cell
        case similarCollection:
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
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
