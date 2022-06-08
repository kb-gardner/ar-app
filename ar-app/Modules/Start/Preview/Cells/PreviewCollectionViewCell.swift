//
//  PreviewCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit
import Kingfisher
import AVKit

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet var customContentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 15
    }
    
    func setup(preview: Preview) {
        guard let stringUrl = preview.stringUrl else { return }
        switch preview.type {
        case .image:
            if let url = URL(string: stringUrl) {
                let imageView = UIImageView(frame: customContentView.frame)
                imageView.kf.setImage(with: url)
                customContentView.addSubview(imageView)
            }
        case .video:
            if let url = URL(string: stringUrl) {
                let player = AVPlayer(url: url)
                let layer = AVPlayerLayer(player: player)
                layer.frame = customContentView.frame
                customContentView.layer.addSublayer(layer)
                player.play()
            }
        }
        titleLabel.text = preview.title
        descriptionLabel.text = preview.message
    }
}
