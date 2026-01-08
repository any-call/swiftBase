//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/8.
//

import Foundation
import Combine

@MainActor
public final class ListVM<Item>: ObservableObject {

    @Published public private(set) var state: DataState<Item> = .idle

    private let fetcher: () async throws -> [Item]

    public init(
        fetcher: @escaping () async throws -> [Item]
    ) {
        self.fetcher = fetcher
    }

    // MARK: - 加载（首次 / 刷新）

    public func load() async {
        let currentItems: [Item]?

        switch state {
        case .success(let items):
            currentItems = items
        case .loading(let items):
            currentItems = items
        case .failure(_, let items):
            currentItems = items
        default:
            currentItems = nil
        }

        state = .loading(previous: currentItems)

        do {
            let result = try await fetcher()
            if result.isEmpty {
                state = .empty
            }else {
                state = .success(result)
            }
        } catch {
            state = .failure(
                message: error.localizedDescription,
                previous: currentItems
            )
        }
    }

    // MARK: - 对外只读辅助 计算属性

    public var items: [Item] {
        switch state {
        case .success(let items),
             .loading(let items?),
             .failure(_, let items?):
            return items
        default:
            return []
        }
    }

    public var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    public var error: String? {
        if case .failure(let error, _) = state {
            return error
        }
        return nil
    }
}
