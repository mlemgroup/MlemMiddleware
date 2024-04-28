//
//  ApiPrivateMessageReportView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PrivateMessageReportView.ts
struct ApiPrivateMessageReportView: Codable {
    let private_message_report: ApiPrivateMessageReport
    let private_message: ApiPrivateMessage
    let private_message_creator: ApiPerson
    let creator: ApiPerson
    let resolver: ApiPerson?
}
