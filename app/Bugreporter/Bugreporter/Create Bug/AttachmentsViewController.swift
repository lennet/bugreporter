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
import Quartz

class AttachmentViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var imageView: IKImageView!
    
    var toolbarItems: [NSView] {
        guard let attachment = attachment else {
            return []
        }
        
        switch attachment.type {
        case .image:
            let cropButton = NSButton(frame: NSRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            
            cropButton.title = "Crop"
            cropButton.target = self
            cropButton.action = #selector(crop)
            
            return [cropButton]
        case .video:
            let trimButton = NSButton(frame: NSRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            
            trimButton.title = "Trim"
            trimButton.target = self
            trimButton.action = #selector(trim)
            
            return [trimButton]
        }
        

        
    }
    
    var attachment: Attachment? {
        didSet {
        
            guard let attachment = attachment else {
                hideMediaViews()
                return
            }
            
            if let oldValue = oldValue, oldValue == attachment {
                return
            }
            
            hideMediaViews()
            
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
    }
    
    private func hideMediaViews() {
        playerView.isHidden = true
        imageView.isHidden = true
    }
    
    func show(image: Attachment) {
        imageView.setImageWith(image.url)
        view.setFrameSize(imageView.imageSize())
        imageView.isHidden = false
        imageView.delegate = self
    }
    
    func show(video: Attachment) {
        playerView.player = AVPlayer(url: video.url)
        playerView.isHidden = false
    }
    
    var isCropping = false
    func crop() {
        if isCropping {
            imageView.crop(self)
            imageView.currentToolMode = IKToolModeMove
        } else {
            imageView.currentToolMode = IKToolModeCrop
        }
        isCropping = !isCropping
    }
    
    func trim() {
        guard playerView.canBeginTrimming else {
            // TODO show error
            return
        }
        
        playerView.beginTrimming { (result) in
            switch result {
            case .okButton:
                break
            case .cancelButton:
                break
            }
        }
    }
}
