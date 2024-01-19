//
//  NetworkService.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import Foundation


import Foundation
import UIKit

class NetworkService {
    
    func saveRole (_ role : String) {
        UserDefaults.standard.set(role, forKey: "role")
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func printRequestDetails(request: URLRequest) {
        if let url = request.url {
            print("URL: \(url)")
        }
        
        if let method = request.httpMethod {
            print("Method: \(method)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    
    func login(username: String, password: String, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/user/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestBody = "username=\(username)&password=\(password)"
        request.httpBody = requestBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
//            let dataString = String(data: data, encoding: .utf8)
//            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func getUserInfo (completion: @escaping (Result<Response<User>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8445/user/userInfo") else { return }
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<User>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getStudentsByDormService (dormNumber:String, completion: @escaping (Result<Dorm, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8445/check/getStudentByDorm") else { return }
        
        var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "dormNumber", value: dormNumber)
            ]

            
        
        urlComponents.queryItems = queryItems
        
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Dorm.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func compressImageTo1MB(_ image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        let maxFileSize = 100_000 // 1MB 的大小
        var imageData = image.jpegData(compressionQuality: compressionQuality)

        while (imageData?.count ?? 0) > maxFileSize && compressionQuality > 0 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }

        return imageData
    }
    
    func uploadFile(image: UIImage, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/upload") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

//        guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
//            completion(.failure(URLError(.badURL)))
//            return
//        }
        guard let imageData = compressImageTo1MB(image) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var body = Data()

        // 文件部分
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        // 请求结束标志
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        // 如果需要，添加其他 HTTP 头部
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }

        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func addCheckService (check: CheckData, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/check/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            do {
                let jsonData = try JSONEncoder().encode(check)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func listCheckService (pageNum: Int, pageSize: Int, studentNumber: String, completion: @escaping (Result<Response<CheckList>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8445/check/list") else { return }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "pageNum", value: String(pageNum)),
//            URLQueryItem(name: "pageSize", value: String(pageSize)),
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "author", value: author),
//            URLQueryItem(name: "isbn", value: isbn)
//        ]
        let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "pageNum", value: String(pageNum)),
                URLQueryItem(name: "pageSize", value: String(pageSize)),
                URLQueryItem(name: "studentNumber", value: studentNumber)
            ]
            
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<CheckList>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func addAppealService (appeal: Appeal, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/check/appeal") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            do {
                let jsonData = try JSONEncoder().encode(appeal)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getStudentInfo (studentUserName: String, completion: @escaping (Result<Response<Student>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8445/user/getStudentInfo") else { return }
        
        var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "studentUserName", value: studentUserName)
            ]

            
        
        urlComponents.queryItems = queryItems
        
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<Student>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func listAppealService (pageNum: Int, pageSize: Int, checkerUserName: String, completion: @escaping (Result<Response<AppealHandleData>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8445/check/appeal/list") else { return }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "pageNum", value: String(pageNum)),
//            URLQueryItem(name: "pageSize", value: String(pageSize)),
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "author", value: author),
//            URLQueryItem(name: "isbn", value: isbn)
//        ]
        let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "pageNum", value: String(pageNum)),
                URLQueryItem(name: "pageSize", value: String(pageSize)),
                URLQueryItem(name: "checkerUserName", value: checkerUserName)
            ]
            
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<AppealHandleData>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func rejectService (appeal: AppealHandleSend, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/check/appeal/verifyNo") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            do {
                let jsonData = try JSONEncoder().encode(appeal)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func approveService (appeal: AppealHandleSend, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8445/check/appeal/verifyYes") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            do {
                let jsonData = try JSONEncoder().encode(appeal)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
