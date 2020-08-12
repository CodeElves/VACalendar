import UIKit

public protocol VAMonthHeaderViewDelegate: class {
    func didTapNextMonth()
    func didTapPreviousMonth()
}

public enum VAMonthHeaderViewContentAlignment: Int {
    case left = 0   // without prev/next buttons
    case center // with prev/next buttons
    case right  // without prev/next buttons
}

public struct VAMonthHeaderViewAppearance {
    
    let monthFont: UIFont
    let monthTextColor: UIColor
    let monthTextWidth: CGFloat
    let previousButtonImage: UIImage
    let nextButtonImage: UIImage
    let dateFormatter: DateFormatter
    let contentAlignment: VAMonthHeaderViewContentAlignment

    static public let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    public init(
        monthFont: UIFont = UIFont.systemFont(ofSize: 21),
        monthTextColor: UIColor = UIColor.black,
        monthTextWidth: CGFloat = 150,
        previousButtonImage: UIImage = UIImage(),
        nextButtonImage: UIImage = UIImage(),
        dateFormatter: DateFormatter = VAMonthHeaderViewAppearance.defaultFormatter,
        contentAlignment: VAMonthHeaderViewContentAlignment = .center
    ) {
        self.monthFont = monthFont
        self.monthTextColor = monthTextColor
        self.monthTextWidth = monthTextWidth
        self.previousButtonImage = previousButtonImage
        self.nextButtonImage = nextButtonImage
        self.dateFormatter = dateFormatter
        self.contentAlignment = contentAlignment
    }
    
}

public class VAMonthHeaderView: UIView {
    
    public var appearance = VAMonthHeaderViewAppearance() {
        didSet {
            dateFormatter = appearance.dateFormatter
            setupView()
        }
    }
    
    public weak var delegate: VAMonthHeaderViewDelegate?
    
    private var dateFormatter = DateFormatter()
    private let monthLabel = UILabel()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = 50.0
        let monthLabelOriginX: CGFloat = appearance.contentAlignment == .right ? frame.width - appearance.monthTextWidth : 0
        monthLabel.frame = CGRect(x: monthLabelOriginX, y: 0, width: appearance.monthTextWidth, height: frame.height)
        if appearance.contentAlignment == .center {
            monthLabel.center.x = center.x
        }
        
        previousButton.frame = CGRect(x: monthLabel.frame.minX - buttonWidth, y: 0, width: buttonWidth, height: frame.height)
        nextButton.frame = CGRect(x: monthLabel.frame.maxX, y: 0, width: buttonWidth, height: frame.height)
    }
    
    private func setupView() {
        subviews.forEach{ $0.removeFromSuperview() }
        
        backgroundColor = .white
        monthLabel.font = appearance.monthFont
        monthLabel.textAlignment = NSTextAlignment(rawValue: appearance.contentAlignment.rawValue) ?? .center
        monthLabel.textColor = appearance.monthTextColor
        addSubview(monthLabel)
        
        if appearance.contentAlignment == .center {
            previousButton.setImage(appearance.previousButtonImage, for: .normal)
            previousButton.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
            nextButton.setImage(appearance.nextButtonImage, for: .normal)
            nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
            addSubview(previousButton)
            addSubview(nextButton)
        }

        layoutSubviews()
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        delegate?.didTapNextMonth()
    }
    
    @objc
    private func didTapPrevious(_ sender: UIButton) {
        delegate?.didTapPreviousMonth()
    }
    
}

extension VAMonthHeaderView: VACalendarMonthDelegate {
    
    public func monthDidChange(_ currentMonth: Date) {
        monthLabel.text = dateFormatter.string(from: currentMonth)
    }
}
