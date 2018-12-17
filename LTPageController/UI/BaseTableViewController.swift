//
//  BaseTableViewController.swift
//  TSNaviBarTransitionDemo
//
//  Created by TopSky on 2018/2/8.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {


    var tableView: UITableView!
    fileprivate let cellIdentifier = "cellIdentifier"
    fileprivate var titleArr = [String]()
    fileprivate var actionDict = [Int: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)

        tableView.frame = view.bounds

        add()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func add() {

    }

    func addPushViewcontroller(vcType: UIViewController.Type, title: String) -> Void {
        titleArr.append(title)
        actionDict[titleArr.count] = vcType
    }

    func addAction(title: String, closure:(() -> Void)?) -> Void {
        titleArr.append(title)
        actionDict[titleArr.count] = closure
    }

}

extension BaseTableViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell.textLabel?.text = titleArr[indexPath.row]
        cell.backgroundColor = UIColor.orange
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let action = actionDict[indexPath.row + 1] else {
            return
        }

        if let vcType = action as? UIViewController.Type {
            let vc = vcType.init()
            vc.title = titleArr[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else if let closure = action as? (() -> Void) {
            closure()
        }
    }


}
