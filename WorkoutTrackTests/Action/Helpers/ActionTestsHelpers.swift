//
//  ActionTestsHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation
import GYMHack

func anyAction() -> (model: AddActionModel, local: ActionDTO) {
    let model = AddActionModel(id: UUID(), moveName: "any move", ofType: "any type", detail: [anyDetail().model, anyDetail().model], isOpen: false)
    return (model, model.toLocal())
}
