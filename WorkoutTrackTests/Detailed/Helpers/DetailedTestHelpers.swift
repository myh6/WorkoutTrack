//
//  DetailedTestHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/23.
//

import Foundation
import GYMHack

func anyDetail(id: UUID = UUID(), isDone: Bool = false, weight: Float = 10, reps: Int = 10, time: Date = Date()) -> (model: Detailed, local: DetailedDTO) {
    let model = Detailed(uid: id, setName: "", weight: weight, isDone: isDone, reps: reps, id: id.uuidString, time: time)
    return (model, model.toLocal())
}

func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
    let model = [anyDetail().model, anyDetail().model, anyDetail().model]
    return (model, model.toLocal())
}
