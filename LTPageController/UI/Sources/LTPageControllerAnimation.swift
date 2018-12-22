//
//  LTPageControllerAnimation.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/21.
//  Copyright © 2018 TopSky. All rights reserved.
//

import Foundation
import UIKit

open class LTPageControllerNormalAnimation: LTPageControllerAnimationProtocol {

    public class func config(_ pageController: LTPageController) {
        pageController.scrollView.isPagingEnabled = true
    }

    public class func rect(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, index: Int) -> CGRect {
        let width = pageController.contentWidth
        let height = pageController.contentHeight
        switch pageController.direction {
        case .horizontal:
            let originX = width * CGFloat(index)
            return CGRect(x: originX, y: 0, width: width, height: height)
        case .vertical:
            let originY = height * CGFloat(index)
            return CGRect(x: 0, y: originY, width: width, height: height)
        }
    }
}

open class LTPageControllerStackAnimation: LTPageControllerAnimationProtocol {
    public class func config(_ pageController: LTPageController) {
        pageController.scrollView.isPagingEnabled = true
    }

    public class func rect(_ pageController: LTPageController, contentController: UIViewController, type: LTPageController.ScrollType, index: Int) -> CGRect {
        let width = pageController.contentWidth
        let height = pageController.contentHeight
        switch pageController.direction {
        case .horizontal:
            switch type {
            case .after:
                let x = pageController.scrollView.contentOffset.x
                pageController.scrollView.sendSubviewToBack(contentController.view)
                let rect = CGRect(x: x, y: 0, width: width, height: height)
                return rect
            default:
                let rect = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
                pageController.scrollView.bringSubviewToFront(contentController.view)
                return rect
            }
        case .vertical:
            switch type {
            case .after:
                let y = pageController.scrollView.contentOffset.y
                pageController.scrollView.sendSubviewToBack(contentController.view)
                let rect = CGRect(x: 0, y: y, width: width, height: height)
                return rect
            default:
                let rect = CGRect(x: 0, y: height * CGFloat(index), width: width, height: height)
                pageController.scrollView.bringSubviewToFront(contentController.view)
                return rect
            }
        }
    }
}
