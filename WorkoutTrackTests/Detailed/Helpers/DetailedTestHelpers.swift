//
//  DetailedTestHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/23.
//

import Foundation
import GYMHack

func anyDetail() -> (model: Detailed, local: DetailedDTO) {
    let id = UUID()
    let model = Detailed(uid: id, setName: "", weight: 10, isDone: true, reps: 10, id: id.uuidString)
    return (model, model.toLocal())
}

func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
    let model = [anyDetail().model, anyDetail().model, anyDetail().model]
    return (model, model.toLocal())
}
