//
//  AttachmentManager.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

struct Attachment {
    
    var url: URL
    
    var type: AttachmentType
    
    var title: String {
        get {
            return url.lastPathComponent
        }
    }
    
    var thumbURL: URL? {
        switch type {
        case .image:
            return url
        case.video:
            var thumbURL = url.deletingPathExtension()
            thumbURL.appendPathExtension("thumb")
            return thumbURL
        }
        
    
    }
    
}

enum AttachmentType {
    
    case image
    
    case video
    
    var fileExtension: String {
        get {
            switch self {
            case .image:
                return "png"
            case .video:
                return "mp4"
            }
        }
    }
    
    static var all: [AttachmentType] {
        get {
            return [.image, .video]
        }
    }
    
}

class AttachmentManager {

    static let shared = AttachmentManager()
    
    lazy var documentURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    private init() {
    
    }
    
    func getAll() -> [Attachment] {
        var result: [Attachment] = []
        
        do {
            let documentsPath = documentURL.path
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: documentsPath)
            for fileName in allFiles {
                let fileURL = URL(fileURLWithPath: documentsPath + "/" + fileName)
                if let attachment = getAttachment(for: fileURL) {
                 result.append(attachment)
                }
                
            }
        } catch {
            print("Error occured while fetching files: \(error)")
        }
        
        return result
    }
    
    
    /// Returns an optional attachment with the correct for url (if its exists)
    ///
    /// - parameter url: url of the wanted attachment
    private func getAttachment(for url: URL) -> Attachment? {
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        for type in AttachmentType.all {
            if url.pathExtension == type.fileExtension {
                return Attachment(url: url, type: type)
            }
        }
        
        return nil
    }
    
    
    func getURL(for type: AttachmentType, name: String) -> URL? {
        return documentURL.appendingPathComponent("\(name).\(type.fileExtension)")
    }
    
}
