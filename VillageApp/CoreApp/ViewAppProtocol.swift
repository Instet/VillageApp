//
//  ViewAppProtocol.swift
//  VillageApp
//
//  Created by Руслан Магомедов on 18.11.2022.
//

import Foundation

protocol ViewAppProtocol {
    var presenter: AppPresenterProtocol? { get set }
    var coordinator: ProfileCoordinator? { get set }
}
