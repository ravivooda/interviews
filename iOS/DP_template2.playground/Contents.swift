
func dp(_ k: Int) {
    // Base case
    // Think about number of base possibilities
    let basepossibilities = 100
    // Think about the solution for each of those base possibilities and create the base case array
    let baseval = 0
    var arr = [Int](repeating: baseval, count: basepossibilities)
    
    // Iterate to create the next level of K
    for _ in 1..<k {
        // Iterate over the entire array start from 0, or maybe in reverse
        for j in 0..<arr.count {
            var currmin = arr[j]
            for z in (j+1)..<arr.count {
                // Calculate the cost for inclusion
                let cost = costFunction(j,z)
                
                // For each index right to i, we can ask what is the best optimal subsolution
                // So, overall best possibility will be the smallest of them all
                currmin = min(currmin, arr[z] + cost)
            }
            arr[j] = currmin
        }
    }
}

func costFunction(_ j:Int, _ z:Int) -> Int {
    // Returns the cost of inclusion from j to z
    return 1
}
