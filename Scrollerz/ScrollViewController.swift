import UIKit

class ScrollViewController: UIViewController {
    
    lazy var firstViewController: UIViewController = {
        return storyboard?.instantiateViewController(withIdentifier: "AViewController") as! AViewController
    }()
    
    lazy var secondViewController: UIViewController = {
        return storyboard?.instantiateViewController(withIdentifier: "BViewController") as! BViewController
    }()
    
    lazy var thirdViewController: UIViewController = {
        return storyboard?.instantiateViewController(withIdentifier: "CViewController") as! CViewController
    }()
    
    lazy var fourthViewController: UIViewController = {
        return storyboard?.instantiateViewController(withIdentifier: "DViewController") as! DViewController
    }()
    
    var scrollingControllers: [UIViewController]!
    
    var scrollView: UIScrollView {
        return view as! UIScrollView
    }
    
    var pageSize: CGSize {
        return scrollView.frame.size
    }
    
    weak var scrollViewSelectionDelegate: ScrollViewSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        self.view = scrollView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollingControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]
        for (index, vc) in scrollingControllers.enumerated() {
            // add the scrolling vc as a child
            addChild(vc)
            
            // compute frame for vc
            vc.view.frame = self.frame(for: index)
            
            // add view controller's view as scroll view's subview
            scrollView.addSubview(vc.view)
            
            vc.didMove(toParent: self)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(scrollingControllers.count) * pageSize.width,
                                        height: pageSize.height
        )
    }
    
    func index(for vc: UIViewController) -> Int? {
        let index = scrollingControllers.index { $0 == vc }
        return index
    }
    
    func frame(for index: Int) -> CGRect {
        return CGRect(x: CGFloat(index) * pageSize.width,
                      y: 0,
                      width: pageSize.width,
                      height: pageSize.height
        )
    }
    
    func selectView(at index: Int) {
        let frame = self.frame(for: index)
        scrollView.setContentOffset(frame.origin, animated: false)
    }
    
    public func isControllerVisible(_ controller: UIViewController?) -> Bool {
        guard controller != nil else { return false }
        for i in 0..<scrollingControllers.count {
            if scrollingControllers[i] == controller {
                let controllerFrame = frame(for: i)
                return controllerFrame.intersects(scrollView.bounds)
            }
        }
        return false
    }
    
    public func findVisibleViewControllerIndex() -> Int? {
        for i in 0..<scrollingControllers.count {
            let controllerFrame = frame(for: i)
            if controllerFrame.intersects(scrollView.bounds) {
                return i
            }
        }
        return nil
    }
}

extension ScrollViewController: UIScrollViewDelegate {    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let index = findVisibleViewControllerIndex() else { return }
        scrollViewSelectionDelegate?.didScrollToViewCntroller(with: index)
    }
}

protocol ScrollViewSelectionDelegate: class {
    func didScrollToViewCntroller(with index: Int)
}
