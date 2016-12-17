//
//  EdgeInsetsExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

extension EdgeInsets {

    var inverted: EdgeInsets {
        return EdgeInsets(top: top * -1, left: left * -1, bottom: bottom * -1, right: right * -1)
    }

}
