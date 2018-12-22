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


    var isSub: Bool = false

    let pageController = LTPageController()
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false

        addChild(pageController)
        view.addSubview(pageController.view)

        pageController.view.frame = view.bounds
        pageController.dataSource = self
        pageController.delegate = self
        pageController.animation = LTPageControllerNormalAnimation.self
        pageController.scrollView.bounces =  false
        if isSub {
            pageController.numOfPages = 7
        } else {
            pageController.numOfPages = 2
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
        if isSub {
            let vc = ImageViewController()
            let resultIndex = index + 1
            let imageName = "\(resultIndex).jpg"
            vc.imageView.image = UIImage.init(named: imageName)
            vc.isButton = index == 3
            vc.button.addTarget(self, action: #selector(onClick(target:)), for: .touchUpInside)
            return vc
        } else {
            let vc = ScrollViewController()
            vc.isSub = true
            vc.pageController.scrollView.bounces = false
            return vc
        }


    }

    @objc fileprivate func onClick(target: Any) {
        let index = pageController.currentIndex
        if pageController.direction == .vertical {
            pageController.direction = .horizontal
        } else {
            pageController.direction = .vertical
        }
        pageController.setController(index, animated: false)
//        pageController.direction = .vertical
//        pageController.setController(1, animated: true)
    }
}

