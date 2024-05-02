//
//  BasicAction.swift
//  Mlem
//
//  Created by Sjmarf on 31/03/2024.
//

import SwiftUI

public struct BasicAction: Action {
    public let id: UUID = .init()
    public let isOn: Bool
    
    public let label: String
    public let isDestructive: Bool
    public let color: Color
    
    public let barIcon: String
    public let menuIcon: String
    public let swipeIcon1: String
    public let swipeIcon2: String
    
    /// If this is nil, the BasicAction is disabled
    public var callback: (() -> Void)?
    
    init(
        isOn: Bool,
        label: String,
        color: Color,
        isDestructive: Bool = false,
        barIcon: String,
        menuIcon: String,
        swipeIcon1: String,
        swipeIcon2: String,
        enabled: Bool = true,
        callback: (() -> Void)? = nil
    ) {
        self.isOn = isOn
        self.label = label
        self.isDestructive = isDestructive
        self.color = color
        self.barIcon = barIcon
        self.menuIcon = menuIcon
        self.swipeIcon1 = swipeIcon1
        self.swipeIcon2 = swipeIcon2
        self.callback = enabled ? callback : nil
    }
    
    public static func upvote(isOn: Bool) -> BasicAction {
        .init(
            isOn: isOn,
            label: isOn ? "Undo Upvote" : "Upvote",
            color: Colors.upvoteColor,
            barIcon: Icons.upvote,
            menuIcon: isOn ? Icons.upvoteSquareFill : Icons.upvoteSquare,
            swipeIcon1: isOn ? Icons.resetVoteSquare : Icons.upvoteSquare,
            swipeIcon2: isOn ? Icons.resetVoteSquareFill : Icons.upvoteSquareFill
        )
    }
    
    public static func downvote(isOn: Bool) -> BasicAction {
        .init(
            isOn: isOn,
            label: isOn ? "Undo Downvote" : "Downvote",
            color: Colors.downvoteColor,
            barIcon: Icons.downvote,
            menuIcon: isOn ? Icons.downvoteSquareFill : Icons.downvoteSquare,
            swipeIcon1: isOn ? Icons.resetVoteSquare : Icons.downvoteSquare,
            swipeIcon2: isOn ? Icons.resetVoteSquareFill : Icons.downvoteSquareFill
        )
    }
    
    public static func save(isOn: Bool) -> BasicAction {
        .init(
            isOn: isOn,
            label: isOn ? "Unsave": "Save",
            color: Colors.saveColor,
            barIcon: isOn ? Icons.saveFill : Icons.save,
            menuIcon: isOn ? Icons.saveFill : Icons.save,
            swipeIcon1: isOn ? Icons.unsave : Icons.save,
            swipeIcon2: isOn ? Icons.unsaveFill : Icons.saveFill
        )
    }
}
