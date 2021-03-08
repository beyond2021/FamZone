//
//  Coordinator.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/7/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }// to show and hide viewcontrollers freely
    
    func start()// there might be multiple coordinators
    //1: login flow
    //2: puchasing flow
    //3: first run flow and so on.
}
