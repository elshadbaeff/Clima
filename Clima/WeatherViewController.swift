//
//  ViewController.swift
//  Clima
//
//  Created by Elshad Babaev on 18.08.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.font = .boldSystemFont(ofSize: 22)
        textField.placeholder = "Search"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "21°C"
        label.textColor = UIColor(named: "weatherColour")
        label.font = .boldSystemFont(ofSize: 82)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conditionImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(named: "weatherColour")
        image.image = UIImage(systemName: "sun.max")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Izhevsk"
        label.textColor = UIColor(named: "weatherColour")
        label.font = .boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "background")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "weatherColour")
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    func setupUI() {
        view.addSubview(backgroundImage)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(conditionImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchTextField.widthAnchor.constraint(equalToConstant: 300),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            
            conditionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            conditionImageView.topAnchor.constraint(equalTo: searchButton.bottomAnchor),
            conditionImageView.heightAnchor.constraint(equalToConstant: 180),
            conditionImageView.widthAnchor.constraint(equalToConstant: 150),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            temperatureLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor),
            
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            
            
            
            
        ])
    }
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @objc func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


