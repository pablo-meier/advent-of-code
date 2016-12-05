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
    currPassword := ""
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
            newDigit := string(sum[5])
            currPassword = currPassword + newDigit
        }
        if len(currPassword) == 8 {
            break
        }
    }
    fmt.Printf("%s\n", currPassword)
}
