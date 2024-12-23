//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 12/22/2024.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    @State private var city: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                TextField("Search Location", text: $city)
                    .padding(10)
                    .frame(height: 45)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            if !city.isEmpty {
                                Button(action: {
                                    city = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    )
                
                if !city.isEmpty {
                    Button(action: {
                        viewModel.fetchWeather(for: city, isSavedCity: false)
                        city = ""
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if let weather = viewModel.weather, !weather.isSavedCity {
                // Weather Information for Saved City
                ScrollView {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "")@2x.png")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(weather.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("\(Int(weather.main.temp))°")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 50) {
                                WeatherDetailView(title: "Humidity", value: "\(weather.main.humidity)%")
                                WeatherDetailView(title: "UV", value: "\(weather.main.uv_index ?? 0)")
                                WeatherDetailView(title: "Feels Like", value: "\(weather.main.feels_like)°")
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
            }else if let weather = viewModel.weather {
                VStack(alignment: .leading, spacing: 10) {
                    Text("")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView {
                        HStack {
                            VStack(alignment: .leading, spacing: 18) {
                                Text(weather.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text("\(Int(weather.main.temp))°")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "")@2x.png")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                    }
                }
                
            }else if let errorMessage = viewModel.errorMessage {
                // Display an error message
                Text(errorMessage)
                    .foregroundColor(.red)
                Spacer()
            }else {
                // Empty State
                Spacer(minLength: 170)
                VStack(spacing: 10) {
                    
                    Text("No City Selected")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Please Search For A City")
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
            }
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            if let lastCity = viewModel.loadLastSearchedCity() {
                viewModel.fetchWeather(for: lastCity, isSavedCity: true)
            }
        }
    }
}

struct WeatherDetailView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}
