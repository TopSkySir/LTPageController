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

        if status == .moving {
            let width = pageController.scrollView.frame.width
            let height = pageController.scrollView.frame.height
            let contentOffset = pageController.scrollView.contentOffset
            let direction = pageController.direction
            var origin: CGFloat = 0
            var offset: CGFloat = 0
            switch direction {
            case .horizontal:
                origin = CGFloat(index) * width
                offset = contentOffset.x - origin
            case .vertical:
                origin = CGFloat(index) * height
                offset = contentOffset.y - origin
            }

        }

        let width = pageController.scrollView.frame.width
        let height = pageController.scrollView.frame.height
        return CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
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

