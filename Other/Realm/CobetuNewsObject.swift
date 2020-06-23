//
//  CobetuNewsObject.swift
//  RSS_Matome
//
//  Created by Kimisira on 2020/06/23.
//  Copyright © 2020年 Kimisira. All rights reserved.
//
import Foundation
import RealmSwift

class CobetuNewsObject: Object {
    @objc dynamic var categori: String = ""
    let  newsList = List<CobetuNewsList>()
    
    override static func primaryKey() -> String? {
        return "categori"
    }
    
}

class CobetuNewsList: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var pubDate: String = ""
    @objc dynamic var imgURL: String = ""
    
    //let owners = LinkingObjects(fromType: TitlesObject.self, property: "newsList")
}
