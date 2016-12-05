package main

import (
    "fmt"
    "io"
    "strconv"
    "crypto/md5"
)

func main() {
    doorId := "abbhdwsy"
    currDigit := 0
    currPassword := make([]byte, 8)
    hasBeenSet := make([]bool, 8)
    for {
        currDigit += 1
        h := md5.New()
        currAttempt := doorId + strconv.Itoa(currDigit)
        io.WriteString(h, currAttempt)
        sum := fmt.Sprintf("%x", h.Sum(nil))
        allFives := true
        for i := 0; i < 5; i++ {
            allFives = allFives && (sum[i] == '0')
        }
        if allFives {
            position, err := strconv.Atoi(string(sum[5]))
            if err != nil {
                //panic(err)
                continue
            }
            newDigit := string(sum[6])
            if position < 8 && hasBeenSet[position] != true {
                currPassword[position] = newDigit[0]
                hasBeenSet[position] = true
                entirePassword := true
                for i := 0; i < 8; i++ {
                    entirePassword = entirePassword && hasBeenSet[i]
                }
                if entirePassword {
                    break
                }
            }
        }
    }
    fmt.Printf("%s\n", string(currPassword))
}
