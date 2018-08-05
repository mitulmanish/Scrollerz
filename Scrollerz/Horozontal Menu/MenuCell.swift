import UIKit

class MenuCell: UICollectionViewCell {
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .red : .gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenuLabel()
    }
    
    func setupMenuLabel() {
        let label = menuLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
