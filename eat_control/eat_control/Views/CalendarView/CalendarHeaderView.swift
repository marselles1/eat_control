
import UIKit

open class CalendarHeaderView: UIView {
    
    var style: CalendarView.Style = CalendarView.Style.Default {
        didSet {
            updateStyle()
        }
    }
    
    var monthLabel: UILabel!
    
    var dayLabels = [UILabel]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel = UILabel()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.backgroundColor = UIColor.clear
        self.addSubview(monthLabel)
        
        for _ in 0..<7 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = UIColor.clear
            
            dayLabels.append(label)
            self.addSubview(label)
        }
    }
    
    public func updateStyle() {
        self.monthLabel.textAlignment = NSTextAlignment.center
        self.monthLabel.font = style.headerFont
        self.monthLabel.textColor = style.headerTextColor
        self.monthLabel.backgroundColor = style.headerBackgroundColor
        
        let formatter = DateFormatter()
        formatter.locale = style.locale
        formatter.timeZone = style.calendar.timeZone
        
        let start = style.firstWeekday == .sunday ? 0 : 1
        var i = 0
        
        for index in start..<(start+7) {
            let label = dayLabels[i]
            label.font = style.weekdaysFont
            label.text = style.weekDayTransform == .capitalized ? formatter.shortWeekdaySymbols[(index % 7)].capitalized : formatter.shortWeekdaySymbols[(index % 7)].uppercased()
            label.textColor = style.weekdaysTextColor
            label.textAlignment = .center
            
            i = i + 1
        }

        self.backgroundColor = style.weekdaysBackgroundColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var isRtl = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        
        if #available(iOS 10.0, *) {
            isRtl = self.effectiveUserInterfaceLayoutDirection == .rightToLeft
        }
        else if #available(iOS 9.0, *) {
            isRtl = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        }
        
        self.monthLabel?.frame = CGRect(
            x: 0.0,
            y: style.headerTopMargin,
            width: self.bounds.size.width,
            height: self.bounds.size.height
                - style.headerTopMargin
                - style.weekdaysHeight
                - style.weekdaysBottomMargin
                - style.weekdaysTopMargin
        )
        
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height
                - style.weekdaysBottomMargin
                - style.weekdaysHeight,
            width: self.bounds.size.width / 7.0,
            height: style.weekdaysHeight
        )
        
        if isRtl {
            labelFrame.origin.x = self.bounds.size.width - labelFrame.width
        }
        
        for lbl in self.dayLabels {
            lbl.frame = labelFrame
            
            labelFrame.origin.x += isRtl ? -labelFrame.size.width : labelFrame.size.width
        }
    }
}
