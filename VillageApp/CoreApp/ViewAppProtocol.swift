//
//  ViewAppProtocol.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 18.11.2022.
//

import Foundation

protocol ViewAppProtocol {
    var presentor: AppPresenterProtocol? { get set }
    var coordinator: AppCoordinatorProtocol? { get set }
}
