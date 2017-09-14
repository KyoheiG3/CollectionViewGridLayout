//
//  IndexPathExtension.swift
//  GridView
//
//  Created by Kyohei Ito on 2017/01/21.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import Foundation

extension IndexPath {
    public init(item: Int, column: Int) {
        self.init(item: item, section: column)
    }
    
    public var column: Int {
        get { return section }
        set { section = newValue }
    }
}
