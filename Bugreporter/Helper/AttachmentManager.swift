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
        return url.lastPathComponent
    }
    
    var name: String {
        return title.replacingOccurrences(of: ".\(type.fileExtension)", with: "")
    }
    
    var thumbURL: URL {
        switch type {
        case .image:
            return url
        case.video:
            var thumbURL = url.deletingPathExtension()
            thumbURL.appendPathExtension("thumb")
            return thumbURL
        }
    }
    
    var data: Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Retrieving data for url \(url) failed with error: \(error)")
            return nil
        }
    }
    
    static func ==(left: Attachment, right: Attachment) -> Bool {
        guard left.name == right.name else { return false }
        guard left.type == right.type else { return false }
        guard left.url == right.url else { return false }
        return true
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
        return urls[0]
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
    
    
    /// Saves data to disk
    ///
    /// - parameter data
    /// - parameter name: the name for the new file without extension
    /// - parameter type: the type of the new file
    ///
    /// - returns: whether the operation was successfull or not
    @discardableResult
    func save(data: Data, name: String, type: AttachmentType) -> Bool {
        let url = getURL(for: type, name: name)
        do {
            try data.write(to: url)
            return true
        } catch {
            print("Could not save Attachment for type:\(type) with error: \(error)")
            return false
        }
    }
    
    /// Deletes attachment from Disk
    ///
    /// - parameter attachment: the attachment which should be deleted
    ///
    /// - returns: whether the operation was successfull or not
    @discardableResult
    func delete(attachment: Attachment) -> Bool {
        
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: attachment.url.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            // file doesn't exist or is directory 
            return false
        }
        
        do {
            try FileManager.default.removeItem(at: attachment.url)
            return true
        } catch {
            return false 
        }
    }
    
    func getURL(for type: AttachmentType, name: String) -> URL {
        return documentURL.appendingPathComponent("\(name).\(type.fileExtension)")
    }
    
}
