//
//  Friend.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/6/21.
//  A Friend
//  Codable - read and writable from disc

import Foundation

struct Friend: Codable {
    var name = "New friend"
    var timeZone = TimeZone.current
}
