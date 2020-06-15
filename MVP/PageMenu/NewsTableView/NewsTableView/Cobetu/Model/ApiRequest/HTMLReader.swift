//
//  HTMLReader.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/26.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import HTMLReader

class HTMLReader {

    func html(str: String) {
        print("Reader HTML")

        let url = URL(string: str)

        do {
            let aaa = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            print(aaa)
        } catch {

        }
        print( )
        //let htmlElement = html.firstNode(matchingSelector: "")
    }

}
