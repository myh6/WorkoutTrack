//
//  ActionTestsHelpers.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation
import GYMHack

func anyAction(id: UUID = UUID(), type: String = "any type", isOpen: Bool = false, details: [DetailedDTO] = [anyDetail().local, anyDetail().local]) -> (model: AddActionModel, local: ActionDTO) {
    let model = AddActionModel(id: id, moveName: "any move", ofType: type, detail: details.map{$0.toDomain()}, isOpen: isOpen)
    return (model, model.toLocal())
}
