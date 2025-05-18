//
//  HomeViewModel.swift
//  StoreApp
//
//  Created by Vijai S on 18/05/25.
//

import Foundation
import Alamofire

class ProductAPI {
    static let shared = ProductAPI()
    private let baseURL = "http://mockup.aabasoft.info/SampleprojectAPI/listproducts"
    var productlistMode : ProductResponse?
    func fetchProducts(pageNumber: Int, pageSize: Int, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "CustomerId": "sNhZrOJ/BHc=",
            "SocietyId": 1,
            "PageNumber": pageNumber,
            "PageSize": pageSize
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ProductResponse.self) { [weak self] response in
                switch response.result {
                case .success(let productResponse):
                    self?.productlistMode = productResponse
                    completion(.success(productResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
