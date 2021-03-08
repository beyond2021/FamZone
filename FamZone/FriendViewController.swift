//
//  FriendViewController.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/6/21.
//

import UIKit

class FriendViewController: UITableViewController, Storeboarded {
    ///Propert
    //2: the selected friend to be edited
    var friend: Friend!
    //3: An array of timezones
    var timeZones = [TimeZone]()
    //4: Index of timezone that is selected. start at the first one
    var selectedTimeZone = 0
    //5: Coordinator link
    weak var coordinator: MainCoordinator?
    
    
    
    ///GET THE CELL ANYWHERE - make first responder
    // get us the top cell so we can get to the textfield tap
    // computed property no equal
    var nameEditingCell: TextTableViewCell? {
        //get the indexPath - ist row / ist section
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextTableViewCell
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Get all the Systems time zones
        let identifiers = TimeZone.knownTimeZoneIdentifiers
        for identifier in identifiers {
            //create Timezone and add it to our array
            if let timezone = TimeZone(identifier: identifier) {
                timeZones.append(timezone)
                
            }
        }
        let now = Date()
        /// timeszones array now hhas all the timezones the system knows about
        //Sort it
        ///DoubleSort
        //1: westernmost to easternmost - diff between ist tz and GMT -$0 1st tz
        //2: by name
        //swift uses 2 different kinds of sorts. this will happen everytime  tableView is loaded so its best to put this in own reusable timezon manager ceate just once
        timeZones.sort {
            let ourDifference = $0.secondsFromGMT(for: now)
            let otherDifference = $1.secondsFromGMT(for: now)
            
            // the same time zone
            if ourDifference == otherDifference {
                // the same
                // sort it by name
                return $0.identifier < $1.identifier
            } else {
                // different time zone sorted by Integer compare
                return ourDifference < otherDifference
            }
        }
        // Sort completed now update the selected tz property
        selectedTimeZone = timeZones.firstIndex(of: friend.timeZone) ?? 0
        
    }
    
    
    
    //PASS DATA BACK HERE
   ///when the textfield changes notify the viewController
    //editing changed - reading everytime they are tyoing
    //Passing Data Back
    // when the vc will go away update the parent
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       coordinator?.updateFriend(friend: friend)
    }
    @IBAction func nameChanged(_ sender: UITextField) {
        friend.name = sender.text ?? " "
    }
    
    
    
    
    
    //TV delegate sections - defalts as 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        //1; name
        //2: all the timezones
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if section zero 1 row
        // section 1 - alltimezones
        if section == 0 {
            return 1
        } else {
            return timeZones.count
        }
    }
    
    //Title for header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name your friend"
        } else {
            return "Select their timezone"
        }
    }
    //The Big one
    // 2 cell classes
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first section - name you friend
        if indexPath.section == 0 {
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextTableViewCell else { fatalError("Couldnt find a TextTableViewCell") }
            cell.textField.text = friend.name
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
            let timeZone = timeZones[indexPath.row]
            cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
            let timeDifference = timeZone.secondsFromGMT(for: Date())
//            cell.detailTextLabel?.text = String(timeDifference)
            cell.detailTextLabel?.text = timeDifference.timeString() // Int Extension
            // show selected time zone
            // is this cell selected give it a checkmark
            // put this in will display method
            if indexPath.row == selectedTimeZone {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        
    }
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //we tapped on the first cell in the first section
            startEditingName()
        } else {
            selectRow(at: indexPath)
        }
    }
    
    //editing cell
    func startEditingName() {
        nameEditingCell?.textField.becomeFirstResponder()
    }
    
    // when they are finish with the textfield - dissmiss keyBoard
    func selectRow(at indexPath: IndexPath ){
        nameEditingCell?.textField.resignFirstResponder()
        //checkmark
        for cell in tableView.visibleCells {
            //all the cells visible on the screen
            cell.accessoryType = .none /// uncheck it
        }
        //update the selected timezone property to chosen one
        selectedTimeZone = indexPath.row
        // upade our friend's timezone
        friend.timeZone = timeZones[indexPath.row]
        // check the one they chose
        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark
        
        //deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
                   
    }
    
    
    
}
