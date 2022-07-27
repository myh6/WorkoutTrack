//
//  Sections.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/25.
//

import Foundation

class Sections {

  var title: String
  var set: [String?]
  var isOpen: Bool = false

  init(title: String,
       set: [String?],
       isOpen: Bool = false
  ) {
    self.title = title
    self.set = set
    self.isOpen = isOpen
  }

}
