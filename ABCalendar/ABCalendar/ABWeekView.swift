//
//  ABWeekView.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

@IBDesignable class ABWeekView: UIView {
    private var week: ABWeek
    private let weekHeight: CGFloat
    private let weekWidth: CGFloat
    
    weak var delegate: ABWeekViewDelegate? = nil
    
    var dayWidth: CGFloat {
        return weekWidth / 7.0
    }
    
    init(week: ABWeek, weekHeight: CGFloat, weekWidth: CGFloat){
        self.week = week
        self.weekWidth = weekWidth
        self.weekHeight = weekHeight
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupDates() {
        var x: CGFloat = 0
        week.days.enumerated().forEach { index, day in
            let dayView = setDay(x: x, day: day, index: index)
            x = dayView.frame.maxX
            addSubview(dayView)
        }
    }
    
    func setDay(x: CGFloat, day: ABDay, index: Int) ->UIView {
        let view = UIView()
        view.frame = CGRect(x: x, y: 0, width: dayWidth, height: self.weekHeight)
        if day.state == .Event || day.state == .Holiday {
            let selectedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            selectedImageView.contentMode = .scaleAspectFit
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            button.tag = index + 100
            button.addTarget(self, action: #selector(ABWeekView.onClickDate(sender:)), for: .touchUpInside)
            
            if day.state == .Event {
                selectedImageView.image = UIImage(named: "redCircle")
                
            }else if day.state == .Holiday {
                selectedImageView.image = UIImage(named: "bluecircle")
            }
            
            view.addSubview(selectedImageView)
            view.addSubview(button)
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = day.day
        label.textColor = UIColor.black
        
        if day.state == .out {
            label.textColor = UIColor.gray
        }
        view.addSubview(label)
        return view
    }
    
    @IBAction func onClickDate(sender: UIButton!) {
        let day = week.days[sender.tag-100]
        delegate?.didSelectDate(day)
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

