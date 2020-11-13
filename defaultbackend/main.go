// MIT License
// Copyright (c) 2020 ysicing <i@ysicing.me>

package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/ysicing/ext/e"
	"github.com/ysicing/ext/ginmid"
	"github.com/ysicing/ext/logger"
	"net/http"
	"time"
)

var (
	FoundDomainCount = prometheus.NewCounter(prometheus.CounterOpts{
		Name: "default_backend_not_exist_domain",
		Help: "访问ingress default backend",
	})
)

func init()  {
	logcfg := logger.Config{Simple: true, ConsoleOnly: true}
	logger.InitLogger(&logcfg)
	prometheus.MustRegister(FoundDomainCount)
}

func main() {
	gin.SetMode(gin.DebugMode)
	gin.DisableConsoleColor()
	r := gin.New()
	r.Use(ginmid.RequestID(), ginmid.Log())

	// Example ping request.
	r.GET("/healthz", func(c *gin.Context) {
		c.String(http.StatusOK, "pong "+fmt.Sprint(time.Now().Unix()))
	})

	// Example / request.
	r.GET("/", func(c *gin.Context) {
		// c.String(http.StatusOK, "default backend. \n\nid: "+mid.GetRequestID(c))
		FoundDomainCount.Inc()
		c.JSON(404, e.Error(10404, map[string]interface{}{
			"message": "default backend",
			"id": ginmid.GetRequestID(c),
			"method": c.Request.Method,
			"url": c.Request.Host,
			"client": c.ClientIP(),
			"ua": c.Request.UserAgent(),
		}))
	})

	// Example /metrics
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// Listen and Server in 0.0.0.0:8080
	r.Run(":8080")
}
