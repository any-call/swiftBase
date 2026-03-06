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
    private var didLoadCache = false
    
    public init(
        cacheKey: String? = nil,
        fetcher: @escaping () async throws -> Item
    ) {
        self.cacheKey = cacheKey
        self.fetcher = fetcher
    }
    
    // MARK: - load
    
    public func load(force: Bool = false) async {
        
        // 防重复请求
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        
        // 只第一次读取缓存
        if !didLoadCache {
            loadCache()
            didLoadCache = true
        }
        
        // 没有数据或强制刷新才 loading
        if item == nil || force {
            state = .loading
        }
        
        do {
            
            let result = try await fetcher()
            
            item = result
            saveCache(result)
            state = .success
            
        } catch {
            
            if item == nil {
                state = .failure(message: error.localizedDescription)
            } else {
                // 有旧数据保持 success
                state = .success
            }
        }
    }
    
    // MARK: - refresh
    
    public func refresh() async {
        await load(force: true)
    }
}

private extension ObjectVM {
    
    func loadCache() {
        guard let cacheKey else { return }
        
        if let cache: Item = try? DiskFileStore.load(Item.self, key: cacheKey) {
            item = cache
            state = .success
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
