//
//  Movie.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation

struct Movie {
    let title:String
    let posterURL:URL?
    let description:String
}

extension Movie: ResultDisplayable {}
