//
//  GroupAction.swift
//  Mlem
//
//  Created by Sjmarf on 31/03/2024.
//

import SwiftUI

public enum ActionGroupMode {
    case section, compactSection, disclosure, popup
}

public struct ActionGroup: Action {
    public let id: UUID = .init()
    
    public let isOn: Bool
    
    public let label: String
    public let isDestructive: Bool
    public let color: Color
    
    public let barIcon: String
    public let menuIcon: String
    public let swipeIcon1: String
    public let swipeIcon2: String
    
    public let enabled: Bool
    public let children: [any Action]
    
    /// Represents how the children of the `ActionGroup` are presented.
    public let displayMode: ActionGroupMode
    
    public init(
        isOn: Bool = false,
        label: String = "More...",
        color: Color = .blue,
        isDestructive: Bool = false,
        barIcon: String = Icons.menuCircle,
        menuIcon: String = Icons.menuCircle,
        swipeIcon1: String = Icons.menuCircle,
        swipeIcon2: String = Icons.menuCircleFill,
        enabled: Bool = true,
        children: [any Action],
        displayMode: ActionGroupMode = .section
    ) {
        self.isOn = isOn
        self.label = label
        self.isDestructive = isDestructive
        self.color = color
        self.barIcon = barIcon
        self.menuIcon = menuIcon
        self.swipeIcon1 = swipeIcon1
        self.swipeIcon2 = swipeIcon2
        self.enabled = enabled
        self.children = children
        self.displayMode = displayMode
    }
}
