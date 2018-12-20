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

    var currentIndex: Int = 0
    var lastSet: Set<Int> = Set(arrayLiteral: 0)
    var direction: ScrollDirection = .horizontal

    var pageCache = [Int: UIViewController]()
    var cacheSize: UInt = 3

    var contentWidth: CGFloat {
        return scrollView.frame.width
    }

    var contentHeight: CGFloat {
        return scrollView.frame.height
    }

    var numOfPages: Int {
        return dataSource?.numberOfPages(self) ?? 0
    }

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

    public enum ScrollType: Int {
        case before
        case after
    }

}


// MARK: - 加载Controller

extension LTPageController {

    /**
     设置contentSize
     */
    func setContentSize() {
        var contentSize = CGSize.zero
        switch direction {
        case .horizontal:
            let result = contentWidth * CGFloat(numOfPages)
            contentSize = CGSize(width: result, height: contentHeight)
        case .vertical:
            let result = contentHeight * CGFloat(numOfPages)
            contentSize = CGSize(width: contentWidth, height: result)
        }
        scrollView.contentSize = contentSize
    }

    /**
     加载正在显示的pageController
     */
    func loadCurrentController() {
        guard currentIndex >= 0, currentIndex < numOfPages else{
            return
        }
        loadController(currentIndex)
    }

    /**
     加载pageController
     */
    @discardableResult
    func loadController(_ index: Int) -> UIViewController? {

        /**
         从cache获取
         */
        guard let cacheVC = getCache(index) else {

            /**
             从代理获取
             */
            guard let sourceVC = dataSource?.controller(self, index: index) else {
                return nil
            }
            addChild(sourceVC)
            setCache(sourceVC, index: index)
            scrollView.addSubview(sourceVC.view)
            return sourceVC
        }

        /**
         添加到ScrollView
         */
        guard cacheVC.view.superview == nil else {
            return cacheVC
        }
        scrollView.addSubview(cacheVC.view)
        return cacheVC
    }

}



// MARK: - reload

extension LTPageController {

    /**
     刷新布局
     */
    func reloadPageFrame(type: ScrollType, index: Int) {
        guard let result = pageCache[index] else {
            return
        }
        let rect = dataSource?.frame(self, contentController: result, type: type, index: index) ?? CGRect.zero
        result.view.frame = rect
    }

    /**
     刷新数据
     */
    func reloadData() {
        let offset = scrollView.contentOffset.x
        let index = offset/contentWidth

        /**
         获取当前展示的page index
         */
        let beforeIndex = Int(floor(index))
        let safeBeforeIndex = max(0, beforeIndex)
        let afterIndex = Int(ceil(index))
        let safeAfterIndex = min(numOfPages, afterIndex)

        let set = Set(arrayLiteral: safeBeforeIndex, safeAfterIndex)

        /**
         获取需要添加的页面
         */
        let appendSet = set.subtracting(lastSet)

        /**
         获取需要移除的页面
         */
        let removeSet = lastSet.subtracting(set)


        /**
         加载page
         */
        appendSet.forEach { (index) in
            loadController(index)
        }

        /**
         移除多余的视图，防止重叠
         */
        removeSet.forEach { (index) in
            let vc = pageCache[index]
            vc?.view.removeFromSuperview()
        }

        /**
         刷新布局
         */
        if set.count == 1 {

            /**
             惯性检查
             如果当前只有一个页面了，沿用上一个Set的reload方式
             */
            if lastSet.count == 2 {
                let max = lastSet.max()!
                let index = set.first!
                if index == max {
                    reloadPageFrame(type: .after, index: index)
                } else {
                    reloadPageFrame(type: .before, index: index)
                }
            }

            /**
             设置当前index
             */
            currentIndex = set.first!

        } else if set.count == 2 {

            /**
             刷新方式
             index 小 对应 before
             index 大 对应 after
             */
            let min = set.min()!
            let max = set.max()!
            reloadPageFrame(type: .before, index: min)
            reloadPageFrame(type: .after, index: max)

            /**
             设置当前index
             如果包含，则不用设置，因为其他情况下已经设置过
             如果不包含，则说明是快速滑动，根据最近的index来设置
             */
            if !set.contains(currentIndex) {
                if currentIndex < min {
                    currentIndex = min
                } else {
                    currentIndex = max
                }
            }
        }
        lastSet = set
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
         刷新数据
         */
        reloadData()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("结束拖拽: \(scrollView.contentOffset)")
//    }
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print("开始减速: \(scrollView.contentOffset)")
//    }


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("执行Stop")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        /**
         清除多余缓存
         */
        cleanCache()

        pageCache.sorted { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
            }.forEach { (item) in
                print("序列: \(item.key),布局: \(item.value.view.frame)")
        }
    }

}
