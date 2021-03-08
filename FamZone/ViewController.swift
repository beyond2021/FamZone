//
//  ViewController.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/6/21.
//

import UIKit

class ViewController: UITableViewController, Storeboarded {
    weak var coordinator: MainCoordinator?
    var friends = [Friend]()
    var selectedFriend: Int? = nil // PASSING DATA called in configure friend

    override func viewDidLoad() {
        super.viewDidLoad()
        /// get stuff from userdefaults
        loadData()
        title = "Fam Zone"
        /// add a friend
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        //#selector tells the compiler to find this method ahead of time(Swift compiler directive)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: Date())
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = indexPath.row
        coordinator?.configureFriend(friend: friends[indexPath.row])
    }
    
    func loadData() {
        let defaults = UserDefaults.standard //user defaults is loaded when the app starts. too big will slow down your app
        guard let savedData = defaults.data(forKey: "Friends") else { return }
        let decoder = JSONDecoder()
        guard let savedFriends = try?decoder.decode([Friend].self, from: savedData) else { return}
        friends = savedFriends
    }
    

    
    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        guard let savedData = try?encoder.encode(friends) else {
            fatalError("Unable to encode friends data.") // should never fail
        }
        defaults.set(savedData, forKey: "Friends")
        
    }
    /// @objc because target actions can only call objc methods
    @objc func addFriend() {
        let friend = Friend() // new friend
        /// Insert into our tableview
        friends.append(friend) // insert the new friend
        ///sync array with the tableView
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()
        /// call configure
        selectedFriend = friends.count - 1
        coordinator?.configureFriend(friend: friend)
    }
 
    
    //:- Update the friend when its changed
    func updateFriend(friend: Friend) {
        guard let selectedFriend = selectedFriend else { return }
        friends[selectedFriend] = friend
        tableView.reloadData()
        saveData()
        
    }
  
}

