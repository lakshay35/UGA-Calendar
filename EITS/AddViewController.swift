//
//  AddViewController.swift
//  EITS
//
//  Created by Lakshay Sharma on 12/9/16.
//  Copyright © 2016 Lakshay Sharma. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UITextField!
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!

    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    var cell: Event? // The cell that populates the objects in the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        
        /*
         *
         *
         Sets up the view for editing if cell is not empty,
         which means that the user selected a cell
         *
         *
         */
        if let cell = cell {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            eventNameLabel.text = cell.eventName
            fromDatePicker.date = dateFormatter.date(from: cell.eventStartDate)!
            toDatePicker.date = dateFormatter.date(from: cell.eventEndDate)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func cancel(_ sender: Any) {
        if(presentingViewController is UINavigationController) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    /*
     *
     *
     Configures error handling if eventNameLabel is empty 
     or if there is a logic error between event timing
     so that the application does not crash
     *
     *
     */
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if (eventNameLabel.text == "") {
            let alert = UIAlertController(title: "Error", message: "\"Event\" field empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (fromDatePicker.date > toDatePicker.date) {
            let alert = UIAlertController(title: "Error", message: "Event start date is after end date. Please correct logic error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "saveButtonPressed", sender: Any?.self)
        }
        
    }
    
    /*
     *
     *
     Edits data so that appropriate data 
     can be pulled from the this file in
     the root view controller
     *
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        cell = Event(name: eventNameLabel.text!, start: dateToString(date: fromDatePicker.date), end: dateToString(date: toDatePicker.date))
    }
    
    /*
     *
     *
     Custom function to convert Date object to
     a String for assignment to String type variables
     *
     *
     */
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
