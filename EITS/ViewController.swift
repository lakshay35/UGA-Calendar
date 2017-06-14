//
//  ViewController.swift
//  EITS
//
//  Created by Lakshay Sharma on 12/9/16.
//  Copyright © 2016 Lakshay Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var data: [[String: String]] = [["Empty": "empty"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self               // To adhere to UITableViewDelegate Protocol
        table.dataSource = self             // To adhere to UITableViewDataSource Protocol
        
        /*
         *
         *
         Retrieves the contents of academiccalendar.json 
         and assigns it to the data variable
         *
         *
         */
        if let path = Bundle.main.path(forResource: "academiccalendar", ofType: "json") {
            do {
                let json = try NSData(contentsOfFile: path, options: .dataReadingMapped)
                data = try JSONSerialization.jsonObject(with: json as Data, options: []) as! [[String:String]]
                
            } catch {
                print(error)
            }
            
        }
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.red // Adds color to the view
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
     *
     *
     sets up the tableView in the specific
     view in Main.storyboard
     *
     *
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /*
     *
     *
     Populates cells in the table view
     *
     *
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?CustomTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //let myCalendar = Calendar(identifier: .gregorian)
        
        /*
         *
         *
         Computes if there an event occurs over 
         the span of one day or multiple days
         and edits the the dayLable based on the 
         computation output
         *
         *
         */
        if(data[indexPath.row]["dtstart"] != data[indexPath.row]["dtend"]) {
            let startDate = dateFormatter.date(from: data[indexPath.row]["dtstart"]!)
            let endDate = dateFormatter.date(from: data[indexPath.row]["dtend"]!)
            cell?.dayLabel.text = "\(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: startDate!)]) - \(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: endDate!)])"
        } else {
            let currentDate = dateFormatter.date(from: data[indexPath.row]["dtstart"]!)
            cell?.dayLabel.text = "\(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: currentDate!)])"
        }
        
        
        cell?.startLabel.text = data[indexPath.row]["dtstart"]
        cell?.endLabel.text = data[indexPath.row]["dtend"]
        cell?.eventLabel.text = data[indexPath.row]["summary"]
         return cell!
    }
   
    
    /*
     *
     *
     Prepares for segue when cell is tapped
     Sets up the variables in the next view 
     so that user can edit the data at will
     *
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let cellDetailViewController = segue.destination as! AddViewController
            if let selectedTableCell = sender as? CustomTableViewCell {
                let indexPath = table.indexPath(for: selectedTableCell)
                let selectedCell = data[(indexPath! as IndexPath).row]
                cellDetailViewController.cell = Event(name: selectedCell["summary"]!, start: selectedCell["dtstart"]!, end: selectedCell["dtend"]!)
            }
        }
    }


    /*
     *
     *
     Allows user to manually delete events of choice
     *
     *
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            data.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    /*
     *
     *
     Updates the table whencells are edited
     or added
     *
     *
     */
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddViewController, let cell = sourceVC.cell {
            if let selectedIndexPath = table.indexPathForSelectedRow {
                data[selectedIndexPath.row] = ["dtstart": cell.eventStartDate, "dtend": cell.eventEndDate, "summary": cell.eventName]
                table.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = NSIndexPath(row: data.count, section: 0)
                data.append(["dtstart": cell.eventStartDate, "dtend": cell.eventEndDate, "summary": cell.eventName])
                table.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            }
        }
        table.reloadData()
    }
    
    /*
     *
     *
     Programs teh actions of the segmented control
     to sort the data in the table view
     *
     *
     */
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            data = data.sorted {
                $0["summary"]! < $1["summary"]!
            }
            table.reloadData()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            data = data.sorted {
                dateFormatter.date(from: $0["dtstart"]!)! < dateFormatter.date(from: $1["dtstart"]!)!
            }
            table.reloadData()
        }
    }
}

