//
//  Types.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

typealias Result<T> = Swift.Result<T, Error>

typealias ResultCompletion<T> = (Result<T>) -> ()
typealias VoidResultCompletion = ResultCompletion<Void>
typealias ArrResultCompletion = ResultCompletion<[Any]>
typealias DictResultCompletion = ResultCompletion<[String:Any]>
typealias DataResultCompletion = ResultCompletion<Data>

typealias DoubleCompletion = (Double) -> ()
