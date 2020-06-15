//
//  ArivalNewsTableViewController.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/12/25.
//  Copyright © 2019年 Kimisira. All rights reserved.
//
import UIKit
import PKHUD

class TopicNewsTableViewController: UIViewController {
    private var tableView: UITableView!

    private var model = NewsTableViewModel()

    //urlのデータ
    private var data = [YahooNewsXMLData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        self.tableViewConfig()
        self.refreshConfig()

        self.getNews()

    }
}

//Refresh系
extension TopicNewsTableViewController {
    func refreshConfig() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    @objc func refreshTable(sender: UIRefreshControl) {
        HUD.show(.progress)
        self.getNews()
        self.tableView.refreshControl?.endRefreshing()

    }
}

extension TopicNewsTableViewController {
    //URLのデータ取りに
    func getNews() {
        let rss = YahooNewsRSS()
        DispatchQueue.init(label: "TopicNewsQueue").async {
            rss.xml_get(str: "https://news.yahoo.co.jp/pickup/rss.xml") { (xmlData) in
                switch xmlData {
                case .success(let response):
                    self.data = response
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.flash(.success, delay: 1.5)
                    }
                case .failure(let error  ):
                    print("news get erroe \(error)")
                    HUD.flash(.error, delay: 1.5)

                }
            }
        }

    }

    func tableViewConfig() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

}

//TableViewDelegate
extension TopicNewsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //NewsサイトをwebViewを開く
        let kiji = KijiViewController(newsURL: self.data[indexPath.row].link)
        self.navigationController?.pushViewController(kiji, animated: true)

    }

}
extension TopicNewsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = data[indexPath.row].pubDate

        return cell
    }

}
