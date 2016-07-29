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
            return url.lastPathComponent!
        }
    }
    
    var thumbURL: URL? {
        switch type {
        case .image:
            return url
        case.video:
            do {
                var thumbURL = try url.deletingPathExtension()
                try thumbURL.appendPathExtension("thumb")
                return thumbURL
            } catch {
                print("Getting thumb url for attachment: \(self) failed with error: \(error)")
                return nil
            }
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
        let urls = FileManager.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    private init() {
    
    }
    
    func getAll() -> [Attachment] {
        var result: [Attachment] = []
        
        do {
            let documentsPath = documentURL.path!
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
        
        guard let path = url.path , FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        
        guard let fileExtension = url.pathExtension else { return nil }
        
        for type in AttachmentType.all {
            if fileExtension == type.fileExtension {
                return Attachment(url: url, type: type)
            }
        }
        
        return nil
    }
    
    
    func getURL(for type: AttachmentType, name: String) -> URL? {
        do {
            return try documentURL.appendingPathComponent("\(name).\(type.fileExtension)")
        } catch {
            print(error)
            return nil
        }

    }
    
}
