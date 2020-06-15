//
//  PageMenuVCPresenter.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/27.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import Foundation
import UIKit

class PageMenuPresenter {
    //Pageのタイトル
    private let titles = PageMenuTitle().titles

}

//３つのVCを設定
extension PageMenuPresenter: PageMenuInPutDelegate {
    var titileArray: [UIViewController] {
        var controllerArray: [UIViewController] = []
        for title in titles {
            if title ==  "設定" {
                let controller1 = ConfigTableViewController()
                controller1.title = title
                controllerArray.append(controller1)
                break
            }
            if title == "新着" {
                let controller1 = TopicNewsTableViewController()
                controller1.title = title
                controllerArray.append(controller1)
                continue
            } else {
                let controller1 = NewsTableViewController()
                let newsModel =  NewsTableViewModel()
                let newsPresenter = NewsTableViewPrsenter(view: controller1, model: newsModel)
                controller1.presenter(presenter: newsPresenter)

                controller1.title = title
                controllerArray.append(controller1)
                continue
            }
        }
        return controllerArray
    }

}
