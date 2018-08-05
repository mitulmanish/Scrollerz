import UIKit

protocol MenuSelectionDelegate: class {
    func didSelectMenu(at index: Int)
}

class HorizontalMenu: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var menuSelectionDelegate: MenuSelectionDelegate?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuSelectionDelegate?.didSelectMenu(at: indexPath.item)
        let distance = CGFloat(indexPath.item) * frame.width / CGFloat(menuData.count)
        selectionViewLeftAnchor?.constant = distance
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.layoutIfNeeded()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / CGFloat(menuData.count), height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    let menuData = ["Movies", "TV", "Korean", "Malay"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MenuCell else {
            return UICollectionViewCell()
        }
        cell.menuLabel.text = menuData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let indicatorView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = .red
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMenuCollectionView()
    }
    
    func setupMenuCollectionView() {
        let menuCV = menuCollectionView
        menuCV.translatesAutoresizingMaskIntoConstraints = false
        menuCV.backgroundColor = .white
        addSubview(menuCV)
        menuCV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuCV.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        menuCV.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        menuCV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        menuCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cell")
        menuCV.delegate = self
        menuCV.dataSource = self
        
        let selectionIndicatorView = indicatorView
        selectionIndicatorView.backgroundColor = .red
        selectionIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectionIndicatorView)
        
        selectionViewLeftAnchor = selectionIndicatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        selectionViewLeftAnchor?.isActive = true
        selectionIndicatorView.topAnchor.constraint(equalTo: menuCV.bottomAnchor, constant: 8).isActive = true
        selectionIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        selectionIndicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(max(menuData.count, 1))).isActive = true
    }
    
    var selectionViewLeftAnchor: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
