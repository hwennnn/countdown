//
//  CalendarViewController.swift
//  countdown
//
//  Created by shadow on 12/1/21.
//

import UIKit
import CVCalendar

class CalendarViewController : UIViewController{

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Appearance delegate [Unnecessary]
        calendarView.calendarAppearanceDelegate = self
        // Animator delegate [Unnecessary]
        calendarView.animatorDelegate = self
        calendarView.delegate = self
        menuView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarViewController : CVCalendarMenuViewDelegate{
    
}

extension CalendarViewController : CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode { return CalendarMode.monthView }
    func firstWeekday() -> Weekday { return Weekday.monday }
}

