//
//  LTPageViewDelegate.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/16.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit

public protocol LTPageControllerDelegate: class {

    func indexChanged(_ pageController: LTPageController, index: Int)

}

public protocol LTPageControllerDataSource: class {

    func controller(_ pageController: LTPageController, index: Int) -> UIViewController?

}

public protocol LTPageControllerAnimationProtocol: class {

    static func config(_ pageController: LTPageController)

    static func rect(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, index: Int) -> CGRect
}

public extension LTPageControllerAnimationProtocol {

    static func config(_ pageController: LTPageController) {

    }

}
