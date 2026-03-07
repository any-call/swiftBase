//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/8.
//

import Foundation
import Combine

@MainActor
public final class ListVM<Item: Codable>: ObservableObject {
    
    @Published public private(set) var items: [Item] = []
    @Published public private(set) var state: DataState = .idle
    
    private let fetcher: () async throws -> [Item]
    private let cacheKey: String?
    
    private var isLoading = false
    
    public init(
        cacheKey: String? = nil,
        fetcher: @escaping () async throws -> [Item]
    ) {
        self.cacheKey = cacheKey
        self.fetcher = fetcher
        loadCache()
    }
    
    // MARK: - 加载
    public func load() async {
        
        // 防止重复请求
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        
        state = .loading
        
        do {
            
            let result = try await fetcher()
            
            items = result
            if result.isEmpty {
                removeCache()
            } else {
                saveCache(result)
            }
            state = .success
            
        } catch {
            
            state = .failure(message: error.localizedDescription)
        }
    }
    
    // MARK: - 手动刷新
    public func refresh() async {
        await load()
    }
}


// MARK: - 缓存扩展
private extension ListVM {
    
    func loadCache() {
        
        guard let cacheKey else { return }
        
        guard let cache: [Item] =
                try? DiskFileStore.load([Item].self, key: cacheKey)
        else { return }
        
        items = cache
    }
    
    func saveCache(_ items: [Item]) {
        
        guard let cacheKey else { return }
        
        try? DiskFileStore.save(items, key: cacheKey)
    }
    
    func removeCache() {
        
        guard let cacheKey else { return }
        
        DiskFileStore.remove(key: cacheKey)
    }
}
