//
//  OCKInsightItem.swift
//  ZombieKit
//
//  Created by Amit Singh on 29/09/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import CareKit

extension OCKInsightItem {
    static func emptyInsightsMessage() -> OCKInsightItem {
        let text = "You haven't entered any data, or reports are in process. (Or you're a zombie?)"
        return OCKMessageItem(title: "No Insights", text: text,
                              tintColor: UIColor.red, messageType: .tip)
    }
}
