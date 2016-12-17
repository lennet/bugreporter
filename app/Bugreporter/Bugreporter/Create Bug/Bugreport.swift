//
//  Bugreport.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

struct Bugreport {
    
    var title: String
    var description: String
    var howToReproduce: String
    var attachments: [Attachment]
    
}

extension Bugreport {

    init() {
        title = ""
        description = ""
        howToReproduce = ""
        attachments = []
    }
    
}
