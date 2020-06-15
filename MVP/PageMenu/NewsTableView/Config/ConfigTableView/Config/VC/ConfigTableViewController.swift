//
//  ConfigTableViewController.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/11/24.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit

class ConfigTableViewController: UIViewController {
    private  var tableView: UITableView!

    private var titles = PageMenuTitle().titles

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self

        self.view = tableView

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MVPを設定
    func titileModel(titleVC: TitlesViewController) {
        let titilesModel = TitlesModel()
        let titlesPresenter = TitlesPresenter(view: titleVC, model: titilesModel)
        titleVC.presenter(presenter: titlesPresenter)
    }

}

extension ConfigTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //1 と 6 以外をクリックしてニュースリスト設定画面へ
        if indexPath.row == 0 || indexPath.row == 7 {

        } else {
            let titlesVC = TitlesViewController()
            self.titileModel(titleVC: titlesVC)
            titlesVC.titleStr = titles[indexPath.row]

            self.navigationController?.pushViewController(titlesVC, animated: true)
        }

    }
}
extension ConfigTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")

        if indexPath.row == 0 || indexPath.row == 7 {

        } else {
            cell.accessoryType = .disclosureIndicator
        }

        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }

}
