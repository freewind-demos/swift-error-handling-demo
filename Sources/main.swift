// swift-error-handling-demo.swift

// ============ 定义错误类型 ============
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

// ============ 抛出错误的函数 ============
func fetchData(from url: String) throws -> String {
    guard !url.isEmpty else {
        throw NetworkError.badURL
    }

    if url.contains("invalid") {
        throw NetworkError.noData
    }

    return "数据内容"
}

// ============ 处理错误 ============
do {
    let result = try fetchData(from: "https://example.com")
    print("成功: \(result)")
} catch NetworkError.badURL {
    print("错误: 无效的URL")
} catch NetworkError.noData {
    print("错误: 没有数据")
} catch {
    print("未知错误: \(error)")
}

// ============ try? 和 try! ============
let result1 = try? fetchData(from: "https://example.com")
print("try? 结果: \(result1 ?? "nil")")

// try! 在确定不会出错时使用
let result2 = try! fetchData(from: "https://example.com")
print("try! 结果: \(result2)")

// ============ defer 语句 ============
func processFile() {
    print("1. 开始处理")

    defer {
        print("4. 清理资源")
    }

    print("2. 执行操作")

    defer {
        print("3. 关闭文件")
    }

    print("操作完成")
}

processFile()

// ============ 自定义错误处理 ============
struct ValidationError: Error, LocalizedError {
    var errorDescription: String? { "验证错误" }
    var field: String
    var message: String

    init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}

func validate(email: String) throws {
    guard email.contains("@") else {
        throw ValidationError(field: "email", message: "邮箱格式不正确")
    }
}

do {
    try validate(email: "test")
} catch let error as ValidationError {
    print("字段: \(error.field), 错误: \(error.message)")
}
