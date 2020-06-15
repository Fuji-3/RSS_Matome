//
//  ConfigObject.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/03.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import UIKit

import RealmSwift

class TitlesObject: Object {
    @objc dynamic var categori: String = ""
    let  newsList = List<NewsList>()

    override static func primaryKey() -> String? {
        return "categori"
    }

}

class NewsList: Object {

    @objc dynamic var newsTitle: String = ""
    @objc dynamic var newsTitleURL: String = ""

    let owners = LinkingObjects(fromType: TitlesObject.self, property: "newsList")
}
