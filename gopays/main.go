package main

import (
  "fmt"
  "github.com/gin-gonic/gin"
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

  db.AutoMigrate(&Gopay{})

  r := gin.Default()
  r.GET("/gopays", GetGopays)
  r.GET("/gopays/:id", GetGopay)
  r.POST("/gopays", CreateGopay)
  r.PUT("/gopays/", UpdateGopay)
  r.DELETE("/gopays/:id", DeleteGopay)
  r.Run(":8083")
}

func GetGopays(c *gin.Context) {
  var gopays []Gopay
  if err := db.Find(&gopays).Error; err != nil {
    c.AbortWithStatus(404)
    fmt.Println(err)
  } else {
    c.JSON(200, gopays)
  }
}

func GetGopay(c *gin.Context) {
  id := c.Params.ByName("id")
  var gopay Gopay
  if err := db.Where("id = ?", id).First(&gopay).Error; err != nil {
    c.AbortWithStatus(404)
    fmt.Println(err)
  } else {
    c.JSON(200, gopay)
  }
}

func CreateGopay(c *gin.Context) {
  var gopay Gopay
  c.BindJSON(&gopay)
  db.Create(&gopay)
  c.JSON(200, gopay)
}

func UpdateGopay(c *gin.Context) {
  var gopay Gopay
  id := c.Params.ByName("id")
  if err := db.Where("id = ?", id).First(&gopay).Error; err != nil {
    c.AbortWithStatus(404)
    fmt.Println(err)
  }
  c.BindJSON(&gopay)
  db.Save(&gopay)
  c.JSON(200, gopay)
}

func DeleteGopay(c *gin.Context) {
  id := c.Params.ByName("id")
  var gopay Gopay
  d := db.Where("id = ?", id).Delete(&gopay)
  fmt.Println(d)
  c.JSON(200, gin.H{"id #" + id: "deleted"})
}