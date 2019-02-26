//
//  RootViewController.swift
//  TSNaviBarTransitionDemo
//
//  Created by TopSky on 2018/2/8.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class RootViewController: BaseTableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book"
//        tableView.isPagingEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func add() {
        addAction(title: "水平方向测试") { [weak self] in
            let vc = ScrollViewController()
            vc.type = 0
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        addAction(title: "垂直方向测试") { [weak self] in
            let vc = ScrollViewController()
            vc.type = 1
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        addAction(title: "水平层叠测试") { [weak self] in
            let vc = ScrollViewController()
            vc.type = 2
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        addAction(title: "垂直层叠测试") { [weak self] in
            let vc = ScrollViewController()
            vc.type = 4
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        addAction(title: "垂直滑动测试") { [weak self] in
            let vc = ScrollViewController()
            vc.type = 3
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
