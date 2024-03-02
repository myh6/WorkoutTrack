//
//  DetailedTestHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/23.
//

import Foundation
import GYMHack

func anyDetail() -> (model: Detailed, local: DetailedDTO) {
    let model = Detailed(uid: UUID(), setName: "any set", weight: 10, isDone: true, reps: 10, id: UUID().uuidString)
    return (model, model.toLocal())
}

func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
    let model = [anyDetail().model, anyDetail().model, anyDetail().model]
    return (model, model.toLocal())
}
