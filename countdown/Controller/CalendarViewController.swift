//
//  CalendarViewController.swift
//  countdown
//
//  Created by zachary on 12/1/21.
//

import UIKit
import CVCalendar
import Foundation
import SideMenu

class CalendarViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var eventTable: UITableView!
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let utils = Utility()
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var shouldShowDaysOut = true
    private var animationFinished = true
    private var selectedDay: DayView!
    private var currentCalendar: Calendar?
    var formatter = DateFormatter()
    
    // Controller
    let eventController = EventController()
    
    // Data structures
    var datesDictionary = [String:[Event]]()
    var eventArr:[Event] = []
    
    
    @IBAction func didTapMenu(){
        present(appDelegate.menu!, animated: true, completion: nil)
    }
    
    func getCurrentMonthLabel() -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM YYYY"
        f.locale = Locale(identifier: "en_SG")
        
        return f.string(from: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datesDictionary = self.loadEventData()
        
        monthLabel.text = getCurrentMonthLabel()
        
        formatter.dateFormat = "dd MMMM, yyyy"
        formatter.locale = Locale(identifier: "en_SG")
        
        calendarView.calendarAppearanceDelegate = self
        calendarView.animatorDelegate = self
        calendarView.delegate = self
        menuView.delegate = self
        calendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = .colorFromCode(1)
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = .colorFromCode(2)
        self.navigationItem.title = "Calendar"
        
        eventTable.delegate = self
        eventTable.dataSource = self

        self.eventTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.datesDictionary = self.loadEventData()
        
        let date = selectedDay.date.convertedDate()!
        let formattedDateString:String = formatter.string(from: date)
        self.eventArr = self.datesDictionary[formattedDateString] ?? []
        self.eventTable.reloadData()
        self.calendarView.contentController.refreshPresentedMonth()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        self.eventTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.eventTable.reloadData()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.eventTable.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! EventTableViewCell

        let event = eventArr[indexPath.row]
        let remainingDateTime = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        
        cell.colourLine.backgroundColor = utils.colourSchemeList[event.colour].colorWithHexString()
        cell.title.text = "\(event.emoji.decodeEmoji) \(event.name)"
        cell.date.text = "\(utils.convertDateToString(event))"
        cell.remaining.text = "\(utils.calculateCountDown(remainingDateTime))"
        cell.remainingDesc.text = "\(utils.getCountDownDesc(remainingDateTime))"
        
        if (Date() > remainingDateTime){
            cell.remaining.textColor = .blue
            cell.remainingDesc.textColor = .blue
        }else{
            cell.remaining.textColor = .black
            cell.remainingDesc.textColor = .black
        }

        return cell
    }
    
    // fetching data from core data and loading datesdictionary
    func loadEventData() -> [String:[Event]]{
        //filling up dictionary (data)
        var dict = [String:[Event]]()
        
        for event in eventController.retrieveAllEvent(){
            let eventDate = formatter.string(from: event.date)
            let keyExists = dict[eventDate] != nil
            if (keyExists) {
                dict[eventDate]?.append(event)
            } else{
                dict[eventDate] = [event]
            }
        }
        
        return dict
    }
    
    // when click on event in table view , redirects to event details page 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarEventDetails", let destination = segue.destination as? EventDetailsViewController {
            if let cell:EventTableViewCell = sender as? EventTableViewCell{
                let row = self.eventTable.indexPath(for: cell)?.row
                destination.event = self.eventArr[row!]
            }
        }
    }
}

extension CalendarViewController : CVCalendarMenuViewDelegate{
    
}

extension CalendarViewController : CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode { return CalendarMode.monthView }
    func firstWeekday() -> Weekday { return Weekday.sunday }
    
    // animations and updating of selected month
    func presentedDateUpdated(_ date: CVDate) {
            if monthLabel.text != date.globalDescription && self.animationFinished {
                let updatedMonthLabel = UILabel()
                updatedMonthLabel.textColor = monthLabel.textColor
                updatedMonthLabel.font = monthLabel.font
                updatedMonthLabel.textAlignment = .center
                updatedMonthLabel.text = date.globalDescription
                updatedMonthLabel.sizeToFit()
                updatedMonthLabel.alpha = 0
                updatedMonthLabel.center = self.monthLabel.center
                
                let offset = CGFloat(48)
                updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
                updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                
                // animating month label
                UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseInOut , animations: {
                    self.animationFinished = false
                    self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                    self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                    self.monthLabel.alpha = 0
                    
                    updatedMonthLabel.alpha = 1
                    updatedMonthLabel.transform = CGAffineTransform.identity
                    
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransform.identity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
                }
                
                self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
                self.calendarView.contentController.refreshPresentedMonth()
            }
        }
    
    
    // update table view when date is click from the calendar ,
    // selecting data from datesDictionary based on date clicked
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        self.selectedDay = dayView
        let formattedDateString:String = formatter.string(from: dayView.date.convertedDate()!)
        self.eventArr = self.datesDictionary[formattedDateString] ?? []
        self.eventTable.reloadData()
    }
    
    // addding a circle to dates where there are events
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        let formattedDateString:String = formatter.string(from: dayView.date.convertedDate()!)
        if let _ = self.datesDictionary[formattedDateString]{
            return true
        }

        return false
    }
    
    // set circle color
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [.systemBlue]
    }
}

