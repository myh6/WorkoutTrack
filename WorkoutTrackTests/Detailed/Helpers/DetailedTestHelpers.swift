//
//  DetailedTestHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/23.
//

import Foundation
import GYMHack

func anyDetail() -> Detailed {
    let model = Detailed(uid: UUID(), setName: "any set", weight: 10, isDone: true, reps: 10, id: "any id")
    return (model)
}

func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
    let model = [anyDetail(), anyDetail(), anyDetail()]
    return (model, model.toLocal())
}
