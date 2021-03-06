//
//  PreviewViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    // MARK: - Properties
    private var previews = [Preview]()
    private var onSuccess: (()->())?
    private var onShowLogin: (()->())?
    
    // MARK: - Outlets
    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var previewCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    // MARK: - Actions
    @IBAction func getStartedClicked(_ sender: Any) {
        showSignUp()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        showLogin()
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewCollection.delegate = self
        previewCollection.dataSource = self
        previewCollection.register(R.nib.previewCollectionViewCell)
        getStartedButton.layer.cornerRadius = 8
        signInButton.layer.cornerRadius = 8
        requestPreviews()
    }
}

private extension PreviewViewController {
    // MARK: - Navigation
    func showSignUp() {
        guard let controller = SignUpViewController.instantiate (onSuccess: { [weak self] in
            // SignUp and Login Complete
            self?.onSuccess?()
        }, onShowLogin: { [weak self] in
            // Login Complete
            self?.showLogin()
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)

    }
    
    func showLogin() {
        onShowLogin?()
    }
    
    // MARK: - Requests
    func requestPreviews() {
        showHUD()
        PreviewNetworkingService.getPreviews { [weak self] previews, error in
            self?.hideHUD()
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    self?.previews = previews ?? []
                    self?.pageControl.numberOfPages = previews?.count ?? 0
                    self?.previewCollection.reloadData()
                }
            }
        }
    }
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.previewCollectionViewCell, for: indexPath)!
        cell.setup(preview: previews[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}

// MARK: - Instantiation
extension PreviewViewController {
    class func instantiate(onSuccess: (()->())?, onShowLogin: (()->())?) -> PreviewViewController? {
        let controller = UIStoryboard(name: R.storyboard.previewViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.previewIdentifier()) as? PreviewViewController
        controller?.onSuccess = onSuccess
        controller?.onShowLogin = onShowLogin
        return controller
    }
}
