//
//  HomeModel.swift
//  MVVM
//
//  Created by Oscar Cardona on 29/02/2020.
//  Copyright © 2020 Cardona.tv. All rights reserved.
//

import Foundation

// MARK: - HomeModel
protocol HomeModel: HomeModelOutput {}

// MARK: - HomeModelOutput Protocol
protocol HomeModelOutput {
    var viewTitle: String? { get }
    var items: [HomeItemModel]? { get }
}

// MARK: - DefaultHomeModel
struct DefaultHomeModel: HomeModel {
    var viewTitle: String?
    var items: [HomeItemModel]?

    init(homeEntity: HomeEntity) {
        self.items = homeEntity.items.map { DefaultHomeItemModel(homeItemEntity: $0) }
    }
}

// MARK: - HomeItemModel
protocol HomeItemModel: HomeItemModelOutput {}

// MARK: - HomeItemModelOutput Protocol
protocol HomeItemModelOutput {
    var title: String? { get }
    var description: String? { get }
    var imageUrl: String? { get }
}

// MARK: - DefaultHomeItemModel
struct DefaultHomeItemModel: HomeItemModel {
    var title: String?
    var description: String?
    var imageUrl: String?

    init(homeItemEntity: HomeItemEntity) {
        self.title = homeItemEntity.title
        self.description = homeItemEntity.description
        self.imageUrl = homeItemEntity.imageUrl
    }
}