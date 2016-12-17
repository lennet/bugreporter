//
//  Bugreport.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

class Bugreport {
 
    init() {
        title = ""
        description = ""
        howToReproduce = ""
        attachments = []
    }

    var title: String
    var description: String
    var howToReproduce: String
    var attachments: [Attachment]
    
}
