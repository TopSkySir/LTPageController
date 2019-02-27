//
//  LTPageView.swift
//  LTPageController
//
//  Created by TopSky on 2018/12/16.
//  Copyright © 2018 TopSky. All rights reserved.
//

import UIKit


open class LTPageController: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    open var scrollView = UIScrollView()

    /**
     动画类型
     */
    open fileprivate(set) var animation: LTPageControllerAnimationProtocol.Type?

    /**
     Delegate
     */
    open fileprivate(set) weak var delegate: LTPageControllerDelegate?

    /**
     DataSource
     */
    open fileprivate(set) weak var dataSource: LTPageControllerDataSource?

    /**
     当前index
     */
    open fileprivate(set) var currentIndex: Int = 0

    /**
     上一次位置信息
     */
    open fileprivate(set) var lastSet: Set<Int> = Set(arrayLiteral: 0)

    /**
     方向
     */
    open fileprivate(set) var direction: ScrollDirection = .horizontal

    /**
     缓存
     */
    open fileprivate(set) var pageCache = [Int: UIViewController]()

    /**
     缓存大小
     */
    open var cacheSize: UInt = 3

    /**
     scrollView宽度
     */
    open var contentWidth: CGFloat {
        return scrollView.frame.width
    }

    /**
     scrollView高度
     */
    open var contentHeight: CGFloat {
        return scrollView.frame.height
    }

    /**
     页数
     */
    open var numOfPages: Int = 0 {
        didSet {
            setContentSize()
            setController(currentIndex, animated: false)
        }
    }

    public required init(delegate: LTPageControllerDelegate, dataSource: LTPageControllerDataSource, animation:  LTPageControllerAnimationProtocol.Type, direction: ScrollDirection) {
        super.init(nibName: nil, bundle: nil)
        self.animation = animation
        self.delegate = delegate
        self.dataSource = dataSource
        self.direction = direction
        animation.config(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }


    open func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.frame = view.frame
        setContentSize()
    }
}

public extension LTPageController {

    public enum ScrollDirection : Int {
        case horizontal
        case vertical
    }

    public enum ScrollType: Int {
        case before
        case after
    }
}


// MARK: - 设置当前选中

public extension LTPageController {

    /**
     设置当前选中
     */
    public func setController(_ index: Int, type: ScrollType = .before, animated: Bool) {
        guard dataSource != nil else {
            currentIndex = index
            return
        }

        guard let vc = loadController(index) else {
            return
        }

        guard let frame = animation?.rect(self, contentController: vc, type: type, index: index) else {
            return
        }

        if !animated {
            reloadPageFrame(type: type, index: index)
        }
        scrollView.setContentOffset(frame.origin, animated: animated)
        currentIndex = index
    }

}

// MARK: - 加载 & 移除

fileprivate extension LTPageController {

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
     设置当前index
     */
    func setCurrentIndex(_ index: Int) {
        guard currentIndex != index else {
            return
        }
        currentIndex = index
        delegate?.indexChanged(self, index: currentIndex)
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
         数组越界检测
         */
        guard index >= 0, index < numOfPages else{
            return nil
        }

        /**
         从cache获取
         */
        guard let cacheVC = getCache(index) else {

            /**
             从代理获取
             */
            let sourceVC = dataSource?.controller(self, index: index)
            setParent(sourceVC, index: index)
            return sourceVC
        }

        /**
         添加到ScrollView
         */
        setSuperView(cacheVC)
        return cacheVC
    }

    /**
     添加到Parent
     */
    func setParent(_ controller: UIViewController?, index: Int) {
        guard let sourceVC = controller else {
            return
        }
        addChild(sourceVC)
        setCache(sourceVC, index: index)
        setSuperView(sourceVC)
    }


    /**
     从Parent移除
     */
    func removeParent(_ index: Int) {
        let vc = removeCache(index)
        removeSuperView(vc)
        vc?.removeFromParent()
    }


    /**
     添加到父试图
     */
    func setSuperView(_ controller: UIViewController?) {
        guard let vc = controller, vc.view.superview == nil else {
            return
        }
        scrollView.addSubview(vc.view)
    }

    /**
     从父试图移除
     */
    func removeSuperView(_ controller: UIViewController?) {
        guard let view = controller?.view else {
            return
        }
        view.removeFromSuperview()
    }

    /**
     从父试图移除
     */
    func removeSuperView(_ index: Int) {
        let vc = getCache(index)
        removeSuperView(vc)
    }

}



// MARK: - Reload刷新

public extension LTPageController {

    /**
     刷新布局
     */
    public func reloadPageFrame(type: ScrollType, index: Int) {
        guard let result = loadController(index) else {
            return
        }
        let rect = animation?.rect(self, contentController: result, type: type, index: index) ?? CGRect.zero
        result.view.frame = rect
    }

    /**
     刷新数据
     */
    public func reloadData() {
        let isHorizontal = (direction == .horizontal)
        let offset = isHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let index = offset/(isHorizontal ? contentWidth : contentHeight)

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
            removeSuperView(index)
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
            setCurrentIndex(set.first!)

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
                    setCurrentIndex(min)
                } else {
                    setCurrentIndex(max)
                }
            }
        }
        lastSet = set
    }

}


// MARK: - Cache缓存

public extension LTPageController {

    /**
     获取缓存
     */
    public func getCache(_ index: Int) -> UIViewController? {
        return pageCache[index]
    }


    /**
     缓存
     */
    public func setCache(_ vc: UIViewController?, index: Int) {
        pageCache[index] = vc
    }


    /**
     移除
     */
    @discardableResult
    public func removeCache(_ index: Int) -> UIViewController? {
        let vc = getCache(index)
        setCache(nil, index: index)
        return vc
    }

    /**
     移除所有缓存
     */
    public func removeAllCache() {
        pageCache.removeAll()
    }

    /**
     清除缓存
     */
    public func cleanCache() {
        /**
         检查缓存数量是否达到Max上限
         */
        let pageCount = pageCache.count
        guard pageCount > cacheSize, pageCount > lastSet.count else {
            return
        }

        /**
         按照距离currentIndex的距离远近排序
         距离近的被用到的可能大
         */
        var cache = pageCache
        lastSet.forEach { (index) in
            cache[index] = nil
        }

        let size = max(Int(cacheSize) - lastSet.count, 0)
        let removeSize = cache.count - size
        let startIndex = cache.count - removeSize
        let endIndex = cache.count

        /**
         获取需要移除的队列
         */
        let keyArr = cache.map { (item) -> Int in
            return item.key
        }.sorted { (lhs, rhs) -> Bool in
            return abs(lhs - currentIndex) < abs(rhs - currentIndex)
        }[startIndex..<endIndex]


        /**
         移除
         */
        keyArr.forEach { (index) in
            removeParent(index)
        }
    }

}


// MARK: - 辅助函数

public extension LTPageController {
    public func logFrame() {
        pageCache.sorted { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
        }.forEach { (item) in
            print("Index: \(item.key), Frame: \(item.value.view.frame)")
        }
    }
}

// MARK: - 滑动代理

extension LTPageController: UIScrollViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**
         刷新数据
         */
        reloadData()
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /**
         清除多余缓存
         */
        cleanCache()
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        /**
         清除多余缓存
         */
        cleanCache()
    }
}
