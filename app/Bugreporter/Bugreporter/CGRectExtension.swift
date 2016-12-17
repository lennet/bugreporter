//
//  CGRectExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGRect {

    func inset(by insets: EdgeInsets) -> CGRect {

        return CGRect(x: origin.x + insets.left, y: origin.y + insets.top, width: width - (insets.left + insets.right), height: height -  (insets.top + insets.bottom))
        
    }

}
