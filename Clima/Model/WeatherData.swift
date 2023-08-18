//
//  WeatherData.swift
//  Clima
//
//  Created by Elshad Babaev on 18.08.2023.
//


import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
