# Swift 错误处理 Demo

## 简介

展示 Swift 的错误处理机制：throw、try-catch、defer。

## 启动和使用

```bash
cd swift-error-handling-demo
swift run
```

## 教程

### 错误处理

```swift
func canThrow() throws -> Type {
    throw SomeError
}
```

### 处理方式

- `do-catch`: 捕获错误
- `try?`: 返回可选值
- `try!`: 强制执行（慎用）
- `defer`: 延迟执行清理代码
