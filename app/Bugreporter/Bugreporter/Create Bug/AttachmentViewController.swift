//
//  AttachmentViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class AttachmentViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var imageView: NSImageView!
    
    var attachment: Attachment? {
        didSet {
            hideMediaViews()
            guard let attachment = attachment else { return }
            switch attachment.type {
            case .image:
                show(image: attachment)
                break
            case .video:
                show(video: attachment)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideMediaViews()
        
        imageView.imageScaling = .scaleProportionallyDown
    }
    
    private func hideMediaViews() {
        playerView.isHidden = true
        imageView.isHidden = true
    }
    
    func show(image: Attachment) {
        imageView.image = NSImage(contentsOf: image.url)
        imageView.isHidden = false
    }
    
    func show(video: Attachment) {
        playerView.player = AVPlayer(url: video.url)
        playerView.isHidden = false
    }
    
}
