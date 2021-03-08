//
//  MainCoordinator.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/7/21.
//  Class because its shared - multiple vc point to this coordinator using a weak reference which you cant do with structs


import UIKit
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    // this method has to instantuate the Mainviewcontroller when called ad show it in its nav controller. it also has to show other viewControllers along the way
    func start() {
        //1: Make our first  viewController from sceneDelegate
        let vc = ViewController.instantiate()
        vc.coordinator = self// tell the viewcontroller how to talk back to us when something interesting has happened
        navigationController.pushViewController(vc, animated: true)
    }
    
    
  //:- SETUP AND PUSH
    func configureFriend(friend: Friend) {
        let vc =  FriendViewController.instantiate()
        vc.coordinator = self
        vc.friend = friend
        navigationController.pushViewController(vc, animated: true)
    }
    //: - UPDATE FRIEND
    func updateFriend(friend: Friend) {
        guard let vc = navigationController.viewControllers.first as? ViewController else { return }
        vc.updateFriend(friend: friend)
    }

    
    
}
