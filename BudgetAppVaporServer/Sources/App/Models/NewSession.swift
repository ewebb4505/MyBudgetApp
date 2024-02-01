//
//  NewSession.swift
//  
//
//  Created by Evan Webb on 1/31/24.
//

import Vapor

struct NewSession: Content {
  let token: String
  let user: User.Public
}
