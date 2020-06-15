//
//  ViewController.swift
//  RSS_Reader
//
//  Created by Kimisira on 2019/11/13.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit

import PageMenuKitSwift

//VC -> Presenterに渡す物
protocol PageMenuInPutDelegate: class {
    var titileArray: [UIViewController] {get}
}

class PageMenuVC: UIViewController {
    var inputDelegate: PageMenuInPutDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.pageMenuSet()

    }
    func present(presenter: PageMenuInPutDelegate) {
        self.inputDelegate = presenter
    }

    func pageMenuSet() {

        //ステータスの高さをもらいPageMenuの画面を作る
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let pageMenuController = PMKPageMenuController(controllers: inputDelegate.titileArray, menuStyle: .Tab, topBarHeight: statusBarHeight)

        // PageMenuwを作る
        self.addChild(pageMenuController)
        self.view.addSubview(pageMenuController.view)
        pageMenuController.didMove(toParent: self)

    }

}
