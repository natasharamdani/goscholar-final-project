package main

import (
  "fmt"
  "github.com/jinzhu/gorm"
  _ "github.com/jinzhu/gorm/dialects/postgres"
)

var db *gorm.DB
var err error

type Gopay struct {
  gorm.Model
  Balance  int    `json:"balance"`
  RefType  string `json:"ref_type"`
  RefID    int    `json:"ref_id"`
}

func main() {
  db, err = gorm.Open("postgres", "dbname=service_gopay user=service_gopay password=password host=localhost sslmode=disable")
  if err != nil {
    fmt.Println(err)
  }
  defer db.Close()

  db.DropTable(&Gopay{})
  db.AutoMigrate(&Gopay{})
}