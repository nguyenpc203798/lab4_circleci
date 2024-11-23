package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

const PORT = "3000"

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong 123",
		})
	})
	r.Run(":" + PORT)
}
