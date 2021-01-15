import UIKit

var str = "Hello, playground"


// Connect for

// API for allowing two users to input their choices
// [User1] [User2]

// Design another function (what is their choice (column)) -> Which user's turn is it

// Connect 4 Game
// Configurations: 7x6, 4 in a row to win

// [ [0] [1, 1] ]

class ConnectGame {
    var columns = [[Int]](repeating: [], count: 7)
    var turn = 1 //
    var isGameOver = false
    
    func iterateCount(_ columnIndex:Int, _ row:Int, _ value:Int, _ rowDelta:Int, _ columnDelta:Int) -> Int {
        var columnIndex = columnIndex
        var row = row
        var counts = 0
        while columnIndex >= 0 && columnIndex < columns.count {
            print("columnIndex: \(columnIndex), \(row)")
            if row < 0 || row >= columns[columnIndex].count {
                break
            }
            
            if columns[columnIndex][row] != value {
                break
            }
            
            columnIndex += columnDelta
            row += rowDelta
            counts += 1
        }
        
        return counts
    }
    
    func play(_ column:Int) -> (Bool, Int?) {
        guard !isGameOver else {
            return (true, turn)
        }
        
        guard column >= 0 else {
            return (false, nil)
        }
        
        guard column < columns.count else {
            return (false, nil)
        }
        
        guard columns[column].count != 6 else {
            return (false, nil)
        }
        
        var currColumn = columns[column]
        currColumn.append(turn)
        columns[column] = currColumn
        
        // Need to check if there is a win
        
        // Column check
        let possibleLeftMostIndex = max(0, currColumn.count-4)
        var last4 = Array(currColumn[possibleLeftMostIndex...])
        if last4.reduce(0, +) == turn * 4 {
            isGameOver = true
            return (true, turn)
        }
        
//        print("Column Checks: \(last4)")
        
        // Row check
        let currTurn = currColumn.last!
        var leftCounts = iterateCount(column-1, currColumn.count - 1, currTurn, 0, -1)
        print("leftCounts: \(leftCounts)")
        var rightCounts = iterateCount(column + 1, currColumn.count - 1, currTurn, 0, 1)
        print("rightCounts: \(rightCounts)")
        
        if rightCounts + leftCounts + 1 >= 4 {
            isGameOver = true
            return (true, turn)
        }
        
        // Diagonally
        var diagonallyLeftCounts = iterateCount(column-1, currColumn.count, currTurn, +1, -1)
//        print("diagonallyLeftCounts: \(diagonallyLeftCounts)")
        var diagonallyRightCounts = iterateCount(column+1, currColumn.count-2, currTurn, -1, +1)
//        print("diagonallyRightCounts: \(diagonallyRightCounts)")
        
        if diagonallyLeftCounts + diagonallyRightCounts + 1 >= 4 {
            isGameOver = true
            return (true, turn)
        }
        
        // Reverse Diagonally
        var reDiagonallyLeftCounts = iterateCount(column-1, currColumn.count-2, currTurn, -1, -1)
        var reDiagonallyRightCounts = iterateCount(column+1, currColumn.count, currTurn, +1, +1)
        
        if reDiagonallyLeftCounts + reDiagonallyRightCounts + 1 >= 4 {
            isGameOver = true
            return (true, turn)
        }
        
        turn = turn == 1 ? 2 : 1
        
        return (false, nil)
    }
}


// Player 1 plays column 0, player 2 plays column 1

var game = ConnectGame()

//print(game.play(0))
//print(game.play(1))
//print(game.play(0))
//print(game.play(1))
//print(game.play(0))
//print(game.play(1))
//print(game.play(0))
//print(game.play(1))
//print(game.play(0))
//print(game.play(1))


print(game.play(0)) // 1
print(game.play(4)) // 2
print(game.play(2))
print(game.play(4))
print(game.play(3))
print(game.play(4))
print(game.play(4))
print(game.play(4))
print(game.play(1))
print(game.play(4))

print(game.columns)
