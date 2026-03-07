//
//  objectVM.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/6.
//
import Foundation
import Combine

@MainActor
public final class ObjectVM<Item: Codable>: ObservableObject {
    
    @Published public private(set) var item: Item?
    @Published public private(set) var state: DataState = .idle
    
    private let fetcher: () async throws -> Item
    private let cacheKey: String?
    
    private var isLoading = false
    
    public init(
        cacheKey: String? = nil,
        fetcher: @escaping () async throws -> Item
    ) {
        self.cacheKey = cacheKey
        self.fetcher = fetcher
        loadCache()
    }
    
    // MARK: - load
    
    public func load() async {
        
        // 防重复请求
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        
        state = .loading
        
        do {
            
            let result = try await fetcher()
            
            item = result
            saveCache(result)
            state = .success
            
        } catch {
            state = .failure(message: error.localizedDescription)
        }
    }
    
    // MARK: - refresh
    
    public func refresh() async {
        await load()
    }
}

private extension ObjectVM {
    
    func loadCache() {
        guard let cacheKey else { return }
        
        if let cache: Item = try? DiskFileStore.load(Item.self, key: cacheKey) {
            item = cache
        }
    }
    
    func saveCache(_ item: Item) {
        
        guard let cacheKey else { return }
        
        try? DiskFileStore.save(item, key: cacheKey)
    }
    
    func removeCache() {
        
        guard let cacheKey else { return }
        
        DiskFileStore.remove(key: cacheKey)
    }
}
