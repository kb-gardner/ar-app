//
//  ImagesViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/12/22.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController {
    // MARK: - Properties
    private var imageUrls = [String]()
    
    // MARK: - Outlets
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var collection: UICollectionView!
    
    // MARK: - Actions
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.register(R.nib.imageCollectionViewCell)
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }
}

private extension ImagesViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Collection
extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.imageCollectionViewCell, for: indexPath)!
        cell.setup(imageUrl: imageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK: - Properties
extension ImagesViewController {
    class func instantiate(imageUrls: [String]) -> ImagesViewController? {
        let controller = UIStoryboard(name: R.storyboard.imagesViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.imagesIdentifier()) as? ImagesViewController
        controller?.imageUrls = imageUrls
        return controller
    }
}
