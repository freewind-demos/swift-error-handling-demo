# Swift 错误处理 Demo

## 简介

本 demo 展示 Swift 的错误处理机制：throw、try-catch、defer。Swift 的错误处理是**类型安全的**，让程序可以优雅地处理各种错误情况。

## 基本原理

### Swift 错误处理的特点

Swift 的错误处理和其他语言（如 Java、Python）有所不同：

1. **错误是类型**：错误用枚举表示
2. **必须显式处理**：调用抛出错误的函数必须处理错误
3. **类型安全**：编译器强制处理错误

### 错误处理流程

```
函数 throw Error
      │
      ▼
   调用者
      │
      ├─► do-catch 捕获
      ├─► try? 转换为可选值
      └─► try! 强制处理（危险）
```

---

## 启动和使用

### 环境要求

- Swift 5.0+
- macOS 或 Linux

### 安装和运行

```bash
cd swift-error-handling-demo
swift run
---

## 教程

### 定义错误类型

Swift 错误用枚举表示：

```swift
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}
```

### 抛出错误

使用 `throw` 关键字抛出错误：

```swift
func fetchData(from url: String) throws -> String {
    guard !url.isEmpty else {
        throw NetworkError.badURL  // 抛出错误
    }

    if url.contains("invalid") {
        throw NetworkError.noData
    }

    return "数据内容"
}
```

注意：
- 函数签名需要 `throws` 关键字
- 函数内使用 `throw` 抛出错误

### do-catch：捕获错误

最常用的错误处理方式：

```swift
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
```

**注意**：
- catch 会按顺序匹配
- 最后一个 catch 可以捕获所有错误
- 使用 `error` 变量访问错误

### try?：转换为可选值

如果只关心成功或失败，不关心具体错误：

```swift
let result1 = try? fetchData(from: "https://example.com")
print("try? 结果: \(result1 ?? "nil")")
```

`try?` 会把错误转换为 nil，成功时返回可选值。

### try!：强制执行

**警告**：只有确定不会出错时才使用 `try!`：

```swift
let result2 = try! fetchData(from: "https://example.com")
print("try! 结果: \(result2)")
```

如果出错，程序会崩溃。

### defer：延迟执行

`defer` 会在函数退出前执行，常用于清理资源：

```swift
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
```

**输出顺序**：
```
1. 开始处理
2. 执行操作
操作完成
3. 关闭文件
4. 清理资源
```

**注意**：
- defer 在函数 return 之前执行
- 多个 defer 按逆序执行
- 即使发生错误，defer 也会执行

### 自定义错误

可以实现 `Error` 协议创建自定义错误：

```swift
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
```

---

## 关键代码详解

### 错误的类型安全

```swift
func fetchData(from url: String) throws -> String
```

这个函数签名告诉调用者：
- 可能抛出 NetworkError
- 返回 String

编译器会强制调用者处理错误。

### defer 的实现原理

```swift
func processFile() {
    defer { print("清理资源") }
    defer { print("关闭文件") }
    print("操作完成")
}
```

编译器会把它转换为类似这样的代码：

```swift
func processFile() {
    // defer 队列
    var deferActions: [() -> Void] = []

    // 添加 defer 动作
    deferActions.append { print("关闭文件") }
    deferActions.append { print("清理资源") }

    print("操作完成")

    // 执行 defer（逆序）
    while let action = deferActions.popLast() {
        action()
    }
}
```

---

## 总结

Swift 的错误处理是类型安全的：

1. **throws** — 标记可能抛出错误的函数
2. **throw** — 抛出错误
3. **do-catch** — 捕获和处理错误
4. **try?** — 转换为可选值
5. **try!** — 强制执行（慎用）
6. **defer** — 延迟执行清理代码

最佳实践：
- 优先使用 do-catch 处理错误
- 使用 try? 简化不关心具体错误的场景
- 使用 defer 清理资源
- 避免使用 try!
