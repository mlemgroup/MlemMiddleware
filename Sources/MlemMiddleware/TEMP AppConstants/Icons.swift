//
//  Icon.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-09-13.
//

import Foundation
import SwiftUI

/// SFSymbol names for icons
public enum Icons {
    // votes
    public static let votes: String = "arrow.up.arrow.down.square"
    public static let upvote: String = "arrow.up"
    public static let upvoteSquare: String = "arrow.up.square"
    public static let upvoteSquareFill: String = "arrow.up.square.fill"
    public static let downvote: String = "arrow.down"
    public static let downvoteSquare: String = "arrow.down.square"
    public static let downvoteSquareFill: String = "arrow.down.square.fill"
    public static let resetVoteSquare: String = "minus.square"
    public static let resetVoteSquareFill: String = "minus.square.fill"
    
    // reply/send
    public static let reply: String = "arrowshape.turn.up.left"
    public static let replyFill: String = "arrowshape.turn.up.left.fill"
    public static let send: String = "paperplane"
    public static let sendFill: String = "paperplane.fill"
    
    // save
    public static let save: String = "bookmark"
    public static let saveFill: String = "bookmark.fill"
    public static let unsave: String = "bookmark.slash"
    public static let unsaveFill: String = "bookmark.slash.fill"
    
    // mark read
    public static let markRead: String = "envelope.open"
    public static let markReadFill: String = "envelope.open.fill"
    public static let markUnread: String = "envelope"
    public static let markUnreadFill: String = "envelope.fill"
    
    // moderation
    public static let moderation: String = "shield"
    public static let moderationFill: String = "shield.fill"
    public static let moderationReport: String = "exclamationmark.shield"
    
    // misc post
    public static let posts: String = "doc.plaintext"
    public static let replies: String = "bubble.left"
    public static let unreadReplies: String = "text.bubble"
    public static let textPost: String = "text.book.closed"
    public static let titleOnlyPost: String = "character.bubble"
    public static let pinned: String = "pin.fill"
    public static let websiteIcon: String = "globe"
    public static let read: String = "book"
    
    // post sizes
    public static let postSizeSetting: String = "rectangle.expand.vertical"
    public static let compactPost: String = "rectangle.grid.1x2"
    public static let compactPostFill: String = "rectangle.grid.1x2.fill"
    public static let headlinePost: String = "rectangle"
    public static let headlinePostFill: String = "rectangle.fill"
    public static let largePost: String = "text.below.photo"
    public static let largePostFill: String = "text.below.photo.fill"
    
    // feeds
    public static let federatedFeed: String = "circle.hexagongrid"
    public static let federatedFeedFill: String = "circle.hexagongrid.fill"
    public static let federatedFeedCircle: String = "circle.hexagongrid.circle.fill"
    public static let localFeed: String = "house"
    public static let localFeedFill: String = "house.fill"
    public static let localFeedCircle: String = "house.circle.fill"
    public static let subscribedFeed: String = "newspaper"
    public static let subscribedFeedFill: String = "newspaper.fill"
    public static let subscribedFeedCircle: String = "newspaper.circle.fill"
    public static let savedFeed: String = "bookmark"
    public static let savedFeedFill: String = "bookmark.fill"
    public static let savedFeedCircle: String = "bookmark.circle.fill"
    
    // sort types
    public static let activeSort: String = "popcorn"
    public static let activeSortFill: String = "popcorn.fill"
    public static let hotSort: String = "flame"
    public static let hotSortFill: String = "flame.fill"
    public static let scaledSort: String = "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
    public static let scaledSortFill: String = "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
    public static let newSort: String = "hare"
    public static let newSortFill: String = "hare.fill"
    public static let oldSort: String = "tortoise"
    public static let oldSortFill: String = "tortoise.fill"
    public static let newCommentsSort: String = "exclamationmark.bubble"
    public static let newCommentsSortFill: String = "exclamationmark.bubble.fill"
    public static let mostCommentsSort: String = "bubble.left.and.bubble.right"
    public static let mostCommentsSortFill: String = "bubble.left.and.bubble.right.fill"
    public static let controversialSort: String = "bolt"
    public static let controversialSortFill: String = "bolt.fill"
    public static let topSortMenu: String = "text.line.first.and.arrowtriangle.forward"
    public static let topSort: String = "trophy"
    public static let topSortFill: String = "trophy.fill"
    public static let timeSort: String = "calendar.day.timeline.leading"
    public static let timeSortFill: String = "calendar.day.timeline.leading"
    
    // user flairs
    public static let developerFlair: String = "hammer.fill"
    public static let adminFlair: String = "crown.fill"
    public static let botFlair: String = "terminal.fill"
    public static let opFlair: String = "person.fill"
    public static let bannedFlair: String = "multiply.circle"
    
    // entities/general Lemmy concepts
    public static let federation: String = "point.3.filled.connected.trianglepath.dotted"
    public static let instance: String = "server.rack"
    public static let user: String = "person.crop.circle"
    public static let userFill: String = "person.crop.circle.fill"
    public static let userBlock: String = "person.fill.xmark"
    public static let community: String = "building.2.crop.circle"
    public static let communityFill: String = "building.2.crop.circle.fill"
    
    // tabs
    public static let feeds: String = "scroll"
    public static let feedsFill: String = "scroll.fill"
    public static let inbox: String = "mail.stack"
    public static let inboxFill: String = "mail.stack.fill"
    public static let search: String = "magnifyingglass"
    public static let searchActive: String = "text.magnifyingglass"
    public static let settings: String = "gear"
    
    // information/status
    public static let success: String = "checkmark"
    public static let successCircle: String = "checkmark.circle"
    public static let successSquareFill: String = "checkmark.square.fill"
    public static let failure: String = "xmark"
    public static let present: String = "circle.fill" // that's present as in "here," not as in "gift"
    public static let absent: String = "circle"
    public static let warning: String = "exclamationmark.triangle"
    public static let hide: String = "eye.slash"
    public static let show: String = "eye"
    public static let blurNsfw: String = "eye.trianglebadge.exclamationmark"
    public static let noContent: String = "binoculars"
    public static let noPosts: String = "text.bubble"
    public static let time: String = "clock"
    public static let updated: String = "clock.arrow.2.circlepath"
    public static let favorite: String = "star"
    public static let favoriteFill: String = "star.fill"
    public static let unfavorite: String = "star.slash"
    public static let unfavoriteFill: String = "star.slash.fill"
    public static let person: String = "person"
    public static let personFill: String = "person.fill"
    public static let close: String = "multiply"
    public static let cakeDay: String = "birthday.cake"
    
    // end of feed
    public static let endOfFeedHobbit: String = "figure.climbing"
    public static let endOfFeedCartoon: String = "figure.wave"
    
    // common operations
    public static let share: String = "square.and.arrow.up"
    public static let subscribe: String = "plus.circle"
    public static let subscribed: String = "checkmark.circle"
    public static let subscribePerson: String = "person.crop.circle.badge.plus"
    public static let subscribePersonFill: String = "person.crop.circle.badge.plus.fill"
    public static let unsubscribe: String = "multiply.circle"
    public static let unsubscribePerson: String = "person.crop.circle.badge.xmark"
    public static let unsubscribePersonFill: String = "person.crop.circle.badge.xmark.fill"
    public static let filter: String = "line.3.horizontal.decrease.circle"
    public static let filterFill: String = "line.3.horizontal.decrease.circle.fill"
    public static let menu: String = "ellipsis"
    public static let menuCircle: String = "ellipsis.circle"
    public static let menuCircleFill: String = "ellipsis.circle.fill"
    public static let `import`: String = "square.and.arrow.down"
    public static let attachment: String = "paperclip"
    public static let edit: String = "pencil"
    public static let delete: String = "trash"
    public static let copy: String = "doc.on.doc"
    
    // settings
    public static let upvoteOnSave: String = "arrow.up.heart"
    public static let readIndicatorSetting: String = "book"
    public static let readIndicatorBarSetting: String = "rectangle.leftthird.inset.filled"
    public static let profileTabSettings: String = "person.text.rectangle"
    public static let nicknameField: String = "rectangle.and.pencil.and.ellipsis"
    public static let label: String = "tag"
    public static let unreadBadge: String = "envelope.badge"
    public static let showAvatar: String = "person.fill.questionmark"
    public static let widgetWizard: String = "wand.and.stars"
    public static let thumbnail: String = "photo"
    public static let author: String = "signature"
    public static let websiteAddress: String = "link"
    public static let leftRight: String = "arrow.left.arrow.right"
    public static let developerMode: String = "wrench.adjustable.fill"
    public static let limitImageHeightSetting: String = "rectangle.compress.vertical"
    public static let appLockSettings: String = "lock.app.dashed"
    public static let collapseComments: String = "arrow.down.and.line.horizontal.and.arrow.up"
    public static let ban: String = "xmark.circle"
    
    // misc
    public static let `private`: String = "lock"
    public static let email: String = "envelope"
    public static let photo: String = "photo"
    public static let switchUser: String = "person.crop.circle.badge.plus"
    public static let missing: String = "questionmark.square.dashed"
    public static let connection: String = "antenna.radiowaves.left.and.right"
    public static let haptics: String = "hand.tap"
    public static let transparency: String = "square.on.square.intersection.dashed"
    public static let icon: String = "fleuron"
    public static let banner: String = "flag"
    public static let noWifi: String = "wifi.slash"
    public static let easterEgg: String = "gift.fill"
    public static let jumpButton: String = "chevron.down"
    public static let jumpButtonCircle: String = "chevron.down.circle"
    public static let browser: String = "safari"
    public static let emptySquare: String = "square"
    public static let dropdown: String = "chevron.down"
    public static let noFile: String = "questionmark.folder"
    public static let forward: String = "chevron.right"
    public static let imageDetails: String = "doc.badge.ellipsis"
}
