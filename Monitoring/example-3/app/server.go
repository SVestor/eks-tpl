package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// This variable is set during build through -ldflags
var Version = "latest"

type Device struct {
	ID  int    `json:"id"`
	MAC string `json:"mac"`
}

var dvs []Device

func init() {
	// Initialize devices
	dvs = []Device{
		{ID: 1, MAC: "E9-CF-45-FD-18-B3"},
		{ID: 2, MAC: "CD-6A-9B-70-BF-EA"},
	}

	// Seed the random number generator once
	rand.Seed(time.Now().UnixNano())
}

func main() {
	fmt.Println("🚀 App version:", Version)

	r := gin.Default()

	// Endpoints
	r.GET("/devices", getDevices)
	r.POST("/devices", createDevices)
	r.DELETE("/devices/:id", deleteDevice)
	r.PUT("/devices/:id", upgradeDevice)
	r.POST("/login", login)

	// Show version
	r.GET("/version", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"version": Version})
	})

	// Run server
	r.Run(":8080")
}

func getDevices(c *gin.Context) {
	sleep(100)
	c.JSON(http.StatusOK, dvs)
}

func createDevices(c *gin.Context) {
	sleep(100)
	c.JSON(http.StatusCreated, gin.H{"message": "Created!"})
}

func upgradeDevice(c *gin.Context) {
	sleep(100)
	c.JSON(http.StatusAccepted, gin.H{"message": "Upgrade started..."})
}

func deleteDevice(c *gin.Context) {
	sleepError(10)
	c.JSON(http.StatusForbidden, gin.H{"message": "failed to delete."})
}

func login(c *gin.Context) {
	sleepError(10)
	c.JSON(http.StatusInternalServerError, gin.H{"message": "Internal error!"})
}

// Simulates a delay with a random time
func sleep(ms int) {
	n := rand.Intn(ms + time.Now().Second()*2)
	time.Sleep(time.Duration(n) * time.Millisecond)
}

func sleepError(ms int) {
	n := rand.Intn(ms + time.Now().Second())
	time.Sleep(time.Duration(n) * time.Millisecond)
}
