import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollContainerView: UIView!
    
    var scrollViewController: ScrollViewController!
    
    let menuView: HorizontalMenu = {
        return HorizontalMenu(frame: .zero)
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
    }
    
    func setupMenuView() {
        menuView.menuSelectionDelegate = self
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)
        [menuView.topAnchor.constraint(equalTo: view.topAnchor),
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        menuView.bottomAnchor.constraint(equalTo: scrollContainerView.topAnchor)
            ].forEach { $0.isActive = true}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollViewController.scrollViewSelectionDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "scrollIdentifier", let scrollVC = segue.destination as? ScrollViewController else {
            return
        }
        scrollViewController = scrollVC
    }
}


extension ViewController: MenuSelectionDelegate {
    func didSelectMenu(at index: Int) {
        guard let scrollVC = scrollViewController else { return }
        scrollVC.selectView(at: index)
    }
}

extension ViewController: ScrollViewSelectionDelegate {
    func didScrollToViewCntroller(with index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        menuView.animateSelectionIndicator(indexPath)
        menuView.menuCollectionView.selectItem(at: indexPath,
                                               animated: true,
                                               scrollPosition: .centeredHorizontally
        )
    }
}
