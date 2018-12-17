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

    let pageController = LTPageController()
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false

        addChild(pageController)
        view.addSubview(pageController.view)

        pageController.view.frame = view.bounds
        pageController.dataSource = self
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
    func contentFrame(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, status: LTPageController.ScrollStatus, index: Int) -> CGRect {

        let width = pageController.scrollView.frame.width
        let height = pageController.scrollView.frame.height
        let rect = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
        if status == .moving {
            let contentOffset = pageController.scrollView.contentOffset
            switch type {
            case .before:
                pageController.scrollView.bringSubviewToFront(contentController.view)
                return rect
            case .after:
                pageController.scrollView.sendSubviewToBack(contentController.view)
                let rect = CGRect(x: contentOffset.x, y: 0, width: width, height: height)
                return rect
            case .current:
                if pageController.type == .before {
                    pageController.scrollView.sendSubviewToBack(contentController.view)
                    let rect = CGRect(x: contentOffset.x, y: 0, width: width, height: height)
                    return rect
                }
                else {
                    pageController.scrollView.bringSubviewToFront(contentController.view)
                    return rect
                }
            }
        }

        contentController.view.isHidden = false
        print("起始Frame\(type)： \(rect)")
        return rect
//        return CGRect(x: 0, y:  height * CGFloat(index), width: width, height: height)
    }

    func controller(_ pageController: LTPageController, index: Int) -> UIViewController? {
        guard index < 7 else {
            return nil
        }
        let vc = ImageViewController()
        let resultIndex = index % 3 + 1
        let imageName = "\(resultIndex).jpg"
        vc.imageView.image = UIImage.init(named: imageName)
        return vc
    }


//    func beforeController(_ pageController: LTPageController, currentViewController: UIViewController) -> UIViewController? {
//        return nil
//    }

//    func afterController(_ pageContoller: LTPageController, currentViewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//
//    func scrollDirection(_ pageController: LTPageController) -> LTPageController.ScrollDirection {
//        return .horizontal
//    }

    func numberOfPages(_ pageController: LTPageController) -> Int {
        return 7
    }
}

