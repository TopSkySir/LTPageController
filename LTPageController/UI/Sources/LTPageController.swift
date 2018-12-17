//
//  LTPageView.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/16.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit


class LTPageController: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let scrollView = UIScrollView()
    weak var delegate: LTPageControllerDelegate?
    weak var dataSource: LTPageControllerDataSource?

    var lastContentOffset: CGPoint = CGPoint.zero
    var currentIndex: Int = 0
    var direction: ScrollDirection = .horizontal

    var currentController: UIViewController?
    var beforeController: UIViewController?
    var afterController: UIViewController?
    var pageCache = [Int: UIViewController]()
    var cacheSize: UInt = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.frame = view.frame
        setContentSize()
        loadCurrentController()
    }
}

extension LTPageController {

    public enum ScrollDirection : Int {
        case horizontal
        case vertical
    }

    public enum ScrollStatus: Int {
        case start
        case moving
        case end
    }

    public enum ScrollType: Int {
        case before
        case current
        case after
    }

}


// MARK: - 加载Controller

extension LTPageController {

    /**
     设置contentSize
     */
    func setContentSize() {
//        guard let direction = dataSource?.scrollDirection(self) else {
//            return
//        }

        guard let number = dataSource?.numberOfPages(self), number >= 0 else {
            return
        }

        var contentSize = CGSize.zero
        let width = scrollView.frame.width
        let height = scrollView.frame.height
        switch direction {
        case .horizontal:
            let result = width * CGFloat(number)
            contentSize = CGSize(width: result, height: height)
        case .vertical:
            let result = height * CGFloat(number)
            contentSize = CGSize(width: width, height: result)
        }
        scrollView.contentSize = contentSize
    }

    /**
     设置当前索引
     */
    func setCurrentIndex() {
        let contentOffset = scrollView.contentOffset
        switch direction {
        case .horizontal:
            let width = scrollView.frame.width
            currentIndex = Int(ceil(contentOffset.x/width))
        case .vertical:
            let height = scrollView.frame.height
            currentIndex = Int(ceil(contentOffset.y/height))
        }
        print("当前索引: \(currentIndex)")
    }


    /**
     初始化PageFrame
     */
    func setPageFrame(_ vc: UIViewController?, type: ScrollType, status: ScrollStatus, index: Int) {
        guard let result = vc else {
            return
        }
        result.view.frame = dataSource?.contentFrame(self, contentController: result, type: type, status: status, index: index) ?? CGRect.zero
    }


    /**
     监测滑动方向
     */
    func updateScrollDirection() {
        switch direction {
        case .horizontal:
            let currentX = scrollView.contentOffset.x
            let lastX = lastContentOffset.x
            loadController(currentX, lastX)
        case .vertical:
            let currentY = scrollView.contentOffset.y
            let lastY = lastContentOffset.y
            loadController(currentY, lastY)
        }
    }

    /**
     监测是否加载
     */
    func isLoaded(_ vc: UIViewController?, index: Int) -> Bool {
        guard let result = vc, result.view.tag == index else {
            return false
        }
        return true
    }


    /**
     加载Controller
     */
    func loadController(_ lhs: CGFloat, _ rhs: CGFloat) {
        var index = 0
        let width = scrollView.frame.width
        let height = scrollView.frame.height
        if lhs < rhs  {
            switch direction {
            case .horizontal:
                index = Int(floor(lhs/width))
            case .vertical:
                index = Int(floor(lhs/height))
            }
            loadBeforeController(index)
        } else if lhs > rhs {
            switch direction {
            case .horizontal:
                index = Int(ceil(lhs/width))
            case .vertical:
                index = Int(ceil(lhs/height))
            }
            loadAfterController(index)
        }
    }

    /**
     加载正在显示的pageController
     */
    func loadCurrentController() {
        let count = dataSource?.numberOfPages(self) ?? 0
        guard currentIndex >= 0, currentIndex < count else{
            return
        }
        currentController = loadController(currentIndex)
        setPageFrame(currentController, type: .current, status: .start, index: currentIndex)
    }

    /**
     加载上一个pageController
     */
    func loadBeforeController(_ index: Int) {
        guard index >= 0 else {
            return
        }

        guard !isLoaded(beforeController, index: index) else{
            setPageFrame(currentController, type: .current, status: .moving, index: index + 1)
            setPageFrame(beforeController, type: .before, status: .moving, index: index)
            return
        }

        beforeController = loadController(index)
        setPageFrame(beforeController, type: .before, status: .start, index: index)
    }



    /**
     加载下一个pageController
     */
    func loadAfterController(_ index: Int) {
        let count = dataSource?.numberOfPages(self) ?? 0
        guard index < count  else {
            return
        }

        guard !isLoaded(afterController, index: index) else{
            setPageFrame(currentController, type: .current, status: .moving, index: index - 1)
            setPageFrame(afterController, type: .after, status: .moving, index: index)
            return
        }

        afterController = loadController(index)
        setPageFrame(afterController, type: .after, status: .start, index: index)
    }

    /**
     加载pageController
     */
    func loadController(_ index: Int) -> UIViewController? {
        let vc = getCache(index)
        guard vc == nil else {
            return vc
        }

        guard let result = dataSource?.controller(self, index: index) else {
            return nil
        }
        result.view.tag = index
        result.view.clipsToBounds = true
        addChild(result)
        setCache(result, index: index)
        scrollView.addSubview(result.view)
        return result
    }

}


// MARK: - Cache

extension LTPageController {

    /**
     获取缓存
     */
    func getCache(_ index: Int) -> UIViewController? {
        return pageCache[index]
    }


    /**
     缓存
     */
    func setCache(_ vc: UIViewController?, index: Int) {
        pageCache[index] = vc
    }


    /**
     移除
     */
    @discardableResult
    func removeCache(_ index: Int) -> UIViewController? {
        let vc = getCache(index)
        setCache(nil, index: index)
        return vc
    }

    /**
     清除缓存
     */
    func cleanCache() {
        guard pageCache.count > cacheSize else {
            return
        }

        var keyArr = pageCache.map { (item) -> Int in
            return item.key
        }.sorted { (lhs, rhs) -> Bool in
            return abs(lhs - currentIndex) < abs(rhs - currentIndex)
        }

        while(keyArr.count > cacheSize) {
            let key = keyArr.removeLast()
            let vc = removeCache(key)
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        }
    }

}


// MARK: - 滑动代理

extension LTPageController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**
         监测滑动方向
         */
        updateScrollDirection()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /**
         设置初始contentOffset
         */
        lastContentOffset = scrollView.contentOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("结束拖拽: \(scrollView.contentOffset)")
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("开始减速: \(scrollView.contentOffset)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /**
         设置当前索引
         */
        setCurrentIndex()

        /**
         清除多余缓存
         */
        cleanCache()
    }

}
