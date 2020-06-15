//
//  Extension.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/29.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let value = self.index(of: value) {
            self.remove(at: value)
        }
    }
}
