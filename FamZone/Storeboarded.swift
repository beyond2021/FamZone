//
//  Storeboarded.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/7/21.
//  my protocol - instantiate storeyboards in one central place
// static means on the class returns an instance of Self

import UIKit

protocol Storeboarded {
    static func instantiate() -> Self
}

extension Storeboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)// name of the class
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main) // load my main storyboard
        return storyboard.instantiateViewController(identifier: className) as! Self // Typecast is safe here. Must be itself!
    }
}
