//
//  ServerResponseProcessing.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Protocol used to describe ability to parse received remote data of `Response<Data>` format into acceptible data format
protocol ServerResponseProcessing: AnyObject {
    /// Process response into `success` or `failure` state
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToVoid(result: Result<Data>, logLabel: String, completion: @escaping VoidResultCompletion)
    /// Process response into `success` or `failure` state. If processing result is `success` then it must contain a dictionary of parsed values
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToDict(result: Result<Data>, logLabel: String, completion: @escaping DictResultCompletion)
    /// Process response into `success` or `failure` state. If processing result is `success` then it must contain an array of parsed values
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToArr(result: Result<Data>, logLabel: String, completion: @escaping ArrResultCompletion)
}

extension ServerResponseProcessing {
    
    func processDataResponseToVoid(result: Result<Data>, logLabel: String, completion: @escaping VoidResultCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success:
                dprint("RESPONSE: \(logLabel) - success")
                completion(.success(()))
            case .failure(let error):
                dprint("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
    func processDataResponseToArr(result: Result<Data>, logLabel: String, completion: @escaping ArrResultCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                dprint("RESPONSE: \(logLabel) - success")
                if logLabel == "Instrument Categories" {
                    dprint(">>>Instrument Categories>>> \(String(describing: String(data: data, encoding: .utf8)))")
                }
                do {
                    let arr = try ServerServicesHelper.parseArr(data: data)
                    completion(.success(arr))
                } catch {
                    dprint("RESPONSE: \(logLabel) - Parse failure: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                dprint("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
    func processDataResponseToDict(result: Result<Data>, logLabel: String, completion: @escaping DictResultCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                dprint("RESPONSE: \(logLabel) - success")
                do {
                    let dict = try ServerServicesHelper.parseDict(data: data)
                    completion(.success(dict))
                } catch {
                    dprint("RESPONSE: \(logLabel) - Parse failure: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                dprint("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
}
