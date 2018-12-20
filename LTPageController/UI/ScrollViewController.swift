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

    func frame(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, index: Int) -> CGRect {
        let width = pageController.contentWidth
        let height = pageController.contentHeight
        let rect = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
        switch type {
        case .after:
            let x = pageController.scrollView.contentOffset.x
            pageController.scrollView.sendSubviewToBack(contentController.view)
            let rect = CGRect(x: x, y: 0, width: width, height: height)
            return rect
        default:
            pageController.scrollView.bringSubviewToFront(contentController.view)
            return rect
        }
    }

    func controller(_ pageController: LTPageController, index: Int) -> UIViewController? {
        guard index >= 0, index < 7 else {
            return nil
        }
        let vc = ImageViewController()
        let resultIndex = index + 1
        let imageName = "\(resultIndex).jpg"
        vc.imageView.image = UIImage.init(named: imageName)
        return vc
    }

    func numberOfPages(_ pageController: LTPageController) -> Int {
        return 7
    }
}

