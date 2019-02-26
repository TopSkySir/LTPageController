//
//  ScrollViewController.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/13.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit
import SnapKit


class ScrollViewController: UIViewController {
    var type: Int = 0
    var pageController: LTPageController!
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false
        pageController = getPageController()
        pageController.view.frame = view.bounds
        pageController.numOfPages = 7
        addChild(pageController)
        view.addSubview(pageController.view)
    }

    func getPageController() -> LTPageController {
        switch type {
        case 1:
            let vc = LTPageController(delegate: self, dataSource: self, animation: LTPageControllerNormalAnimation.self, direction: .vertical)
            return vc
        case 2:
            let vc = LTPageController(delegate: self, dataSource: self, animation: LTPageControllerStackAnimation.self, direction: .horizontal)
            return vc
        case 3:
             let vc = LTPageController(delegate: self, dataSource: self, animation: LTPageControllerNormalAnimation.self, direction: .vertical)
             vc.scrollView.isPagingEnabled = false
            return vc
        case 4:
            let vc = LTPageController(delegate: self, dataSource: self, animation: LTPageControllerStackAnimation.self, direction: .vertical)
            return vc
        default:
            let vc = LTPageController(delegate: self, dataSource: self, animation: LTPageControllerNormalAnimation.self, direction: .horizontal)
            return vc
        }
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ScrollViewController: LTPageControllerDataSource,LTPageControllerDelegate {

    func indexChanged(_ pageController: LTPageController, index: Int) {
        print("当前index: \(index)")
    }


    func controller(_ pageController: LTPageController, index: Int) -> UIViewController? {
        let vc = ImageViewController()
        let resultIndex = index + 1
        let imageName = "\(resultIndex).jpg"
        vc.imageView.image = UIImage.init(named: imageName)
        vc.isButton = false
        return vc
//        if isSimple {
//            let vc = ImageViewController()
//            let resultIndex = index + 1
//            let imageName = "\(resultIndex).jpg"
//            vc.imageView.image = UIImage.init(named: imageName)
//            vc.isButton = index == 1
//            let text = pageController.direction == .horizontal ? "水平" : "垂直"
//            let other = pageController.direction == .horizontal ? "垂直" : "水平"
//            vc.button.setTitle("当前滑动方向：\(text)\n点击切换为：\(other)", for: .normal)
//            vc.button.addTarget(self, action: #selector(onClick(target:)), for: .touchUpInside)
//            return vc
//        } else {
//            if isSub {
//                let vc = ImageViewController()
//                let resultIndex = index + 1
//                let imageName = "\(resultIndex).jpg"
//                vc.imageView.image = UIImage.init(named: imageName)
//                vc.isButton = index == 1
//                let text = pageController.direction == .horizontal ? "水平" : "垂直"
//                let other = pageController.direction == .horizontal ? "垂直" : "水平"
//                vc.button.setTitle("当前滑动方向：\(text)\n点击切换为：\(other)", for: .normal)
//                vc.button.addTarget(self, action: #selector(onClick(target:)), for: .touchUpInside)
//                return vc
//            } else {
//                let vc = ScrollViewController()
//                vc.isSub = true
//                vc.pageController.scrollView.bounces = false
//                return vc
//            }
//        }

    }

//    @objc fileprivate func onClick(target: Any) {
//        let index = pageController.currentIndex
//        if pageController.direction == .vertical {
//            pageController.direction = .horizontal
//        } else {
//            pageController.direction = .vertical
//        }
//        pageController.setController(index, animated: false)
//    }
}

