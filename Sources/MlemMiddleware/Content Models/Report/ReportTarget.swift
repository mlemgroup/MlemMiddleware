//
//  ReportTarget.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-16.
//

import Foundation

public enum ReportTarget {
    /// All post reports use this case on 0.19.4 and above.
    case post(Post2)
    /// All comment reports use this case on 0.19.4 and above.
    case comment(Comment2)
    /// All messages reports use this case regardless of version.
    case message(Message2)
    
    // TODO: 0.19.3 deprecation - remove the below two cases and associated code.
    
    // `ApiPostReportView` is a superset of `ApiPostView` from 0.19.4 onwards, allowing
    // us to create a `Post2` (as seen above). However, prior to 0.19.4 this was not the
    // case - only *some* of the necessary properties are included.
    
    // For simplicity I've opted to only store `Post1` on those older versions rather than creating
    // a new intermediate `Post` tier. This solution means losing access to certain information
    // (e.g. vote and save status) but saves significant headache so I think it's easier to just
    // not display vote status on pre-0.19.4 versions.
    
    /// All post reports use this case on 0.19.3 and below.
    case legacyPost(Post1, community: Community1, creator: Person1)
    /// All comment reports use this case on 0.19.3 and below.
    case legacyComment(Comment1, community: Community1, creator: Person1)
    
    internal var typeId: Int {
        switch self {
        case .post, .legacyPost: 0
        case .comment, .legacyComment: 1
        case .message: 2
        }
    }
}
