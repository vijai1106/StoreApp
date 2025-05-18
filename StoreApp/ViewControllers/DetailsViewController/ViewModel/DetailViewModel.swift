//
//  DetailViewModel.swift
//  StoreApp
//
//  Created by Vijai S on 18/05/25.
//

import Foundation
import Alamofire

class ProductDetailAPI {
    static let shared = ProductDetailAPI()
    private let baseURL = "http://mockup.aabasoft.info/SampleprojectAPI/productdetails"
    var productDetailtModel : ProductDetailResponse?
    func fetchProductDetails(productID: Int, completion: @escaping (Result<ProductDetailResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "CustomerId": "sNhZrOJ/BHc=",
            "ProductID": productID,
            "SocietyID": 1
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ProductDetailResponse.self) { [weak self] response in
                switch response.result {
                case .success(let productDetailResponse):
                    self?.productDetailtModel = productDetailResponse
                    completion(.success(productDetailResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
