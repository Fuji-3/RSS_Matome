//
//  NetworkError.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/10/03.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
/*
 Error
 ネットに繋がってない
 URLがおかしい
 */
enum NetworkError: Error {
    case networkError(String)
    case urlError(String)
}
