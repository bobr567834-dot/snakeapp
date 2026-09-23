import SwiftUI

struct ContentView: View {
    @StateObject private var game = SnakeGame()

    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - 120
            let cellSize = min(geo.size.width / CGFloat(game.columns), availableHeight / CGFloat(game.rows))
            let boardWidth = cellSize * CGFloat(game.columns)
            let boardHeight = cellSize * CGFloat(game.rows)

            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Счёт: \(game.score)")
                            .font(.title3).bold()
                        Text("Рекорд: \(game.bestScore)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { game.reset() }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.88))

                    ForEach(Array(game.snake.enumerated()), id: \.offset) { index, point in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(index == 0 ? Color.green : Color.green.opacity(0.75))
                            .frame(width: cellSize - 2, height: cellSize - 2)
                            .position(
                                x: CGFloat(point.x) * cellSize + cellSize / 2,
                                y: CGFloat(point.y) * cellSize + cellSize / 2
                            )
                    }

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.red)
                        .frame(width: cellSize - 2, height: cellSize - 2)
                        .position(
                            x: CGFloat(game.food.x) * cellSize + cellSize / 2,
                            y: CGFloat(game.food.y) * cellSize + cellSize / 2
                        )

                    if game.isGameOver {
                        VStack(spacing: 16) {
                            Text("Игра окончена")
                                .font(.title).bold()
                                .foregroundColor(.white)
                            Text("Счёт: \(game.score)")
                                .font(.title3)
                                .foregroundColor(.white)
                            Button("Заново") {
                                game.reset()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(16)
                    }
                }
                .frame(width: boardWidth, height: boardHeight)
                .gesture(
                    DragGesture(minimumDistance: 15)
                        .onEnded { value in
                            let dx = value.translation.width
                            let dy = value.translation.height
                            if abs(dx) > abs(dy) {
                                game.changeDirection(dx > 0 ? .right : .left)
                            } else {
                                game.changeDirection(dy > 0 ? .down : .up)
                            }
                        }
                )

                // on-screen D-pad as a backup control
                VStack(spacing: 6) {
                    Button(action: { game.changeDirection(.up) }) {
                        Image(systemName: "chevron.up.circle.fill").font(.system(size: 36))
                    }
                    HStack(spacing: 40) {
                        Button(action: { game.changeDirection(.left) }) {
                            Image(systemName: "chevron.left.circle.fill").font(.system(size: 36))
                        }
                        Button(action: { game.changeDirection(.right) }) {
                            Image(systemName: "chevron.right.circle.fill").font(.system(size: 36))
                        }
                    }
                    Button(action: { game.changeDirection(.down) }) {
                        Image(systemName: "chevron.down.circle.fill").font(.system(size: 36))
                    }
                }
                .foregroundColor(.green)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
