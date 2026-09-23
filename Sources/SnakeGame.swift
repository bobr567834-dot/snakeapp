import SwiftUI
import Combine

struct Point: Hashable {
    var x: Int
    var y: Int
}

enum Direction {
    case up, down, left, right

    var vector: Point {
        switch self {
        case .up: return Point(x: 0, y: -1)
        case .down: return Point(x: 0, y: 1)
        case .left: return Point(x: -1, y: 0)
        case .right: return Point(x: 1, y: 0)
        }
    }

    var opposite: Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
}

final class SnakeGame: ObservableObject {
    let columns = 15
    let rows = 25

    @Published var snake: [Point] = []
    @Published var food: Point = Point(x: 5, y: 5)
    @Published var direction: Direction = .right
    @Published var isGameOver = false
    @Published var score = 0
    @Published var bestScore = UserDefaults.standard.integer(forKey: "bestScore")

    private var pendingDirection: Direction = .right
    private var timerCancellable: AnyCancellable?
    private var speed: Double = 0.15

    init() {
        reset()
    }

    func reset() {
        let startX = columns / 2
        let startY = rows / 2
        snake = [
            Point(x: startX, y: startY),
            Point(x: startX - 1, y: startY),
            Point(x: startX - 2, y: startY)
        ]
        direction = .right
        pendingDirection = .right
        isGameOver = false
        score = 0
        speed = 0.15
        placeFood()
        startTimer()
    }

    func changeDirection(_ newDirection: Direction) {
        guard newDirection.opposite != direction else { return }
        pendingDirection = newDirection
    }

    private func startTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: speed, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func placeFood() {
        var newFood: Point
        repeat {
            newFood = Point(x: Int.random(in: 0..<columns), y: Int.random(in: 0..<rows))
        } while snake.contains(newFood)
        food = newFood
    }

    private func tick() {
        guard !isGameOver else { return }
        direction = pendingDirection
        guard let head = snake.first else { return }

        let newHead = Point(x: head.x + direction.vector.x, y: head.y + direction.vector.y)

        if newHead.x < 0 || newHead.x >= columns || newHead.y < 0 || newHead.y >= rows {
            gameOver()
            return
        }

        if snake.contains(newHead) {
            gameOver()
            return
        }

        snake.insert(newHead, at: 0)

        if newHead == food {
            score += 1
            placeFood()
            // slightly speed up every 5 points, capped
            if score % 5 == 0 && speed > 0.06 {
                speed -= 0.01
                startTimer()
            }
        } else {
            snake.removeLast()
        }
    }

    private func gameOver() {
        isGameOver = true
        timerCancellable?.cancel()
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }
}
