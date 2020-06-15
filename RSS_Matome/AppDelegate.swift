//
//  AppDelegate.swift
//  RSS_Matome
//
//  Created by Kimisira on 2019/11/16.
//  Copyright © 2019年 Kimisira. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let startController = PageMenuVC()
        let pageMenuPresenter = PageMenuPresenter()
        startController.present(presenter: pageMenuPresenter)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: startController)
        window?.makeKeyAndVisible()

        //print("uuid \(Realm.Configuration.defaultConfiguration.fileURL!)")
        _ = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { (_, oldScemaVersion) in

                if oldScemaVersion <  1 {
                    print("oldScemaVersion A  \(oldScemaVersion)")
                    //auto mirgate
                }
        })

        //Realm.Configuration.defaultConfiguration = config
        //config = Realm.Configuration()
        //config.deleteRealmIfMigrationNeeded = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
