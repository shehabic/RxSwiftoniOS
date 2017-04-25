//
// Created by Mohamed Osman on 25/04/17.
// Copyright (c) 2017 Underplot ltd. All rights reserved.
//

import Foundation

class ResultSet {
    var results: [Repo]

    init(_ repos: [Repo]) {
        self.results = repos
    }
}