//
//  LTPageViewDelegate.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/16.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit

protocol LTPageControllerDelegate: class {

}

protocol LTPageControllerDataSource: class {

//    func scrollDirection(_ pageController: LTPageController) -> LTPageController.ScrollDirection

    func numberOfPages(_ pageController: LTPageController) -> Int

    func controller(_ pageController: LTPageController, index: Int) -> UIViewController?

    func frame(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, index: Int) -> CGRect

}
