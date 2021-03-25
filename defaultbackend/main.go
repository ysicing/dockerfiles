// MIT License
// Copyright (c) 2020 ysicing <i@ysicing.me>

package main

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/ysicing/ext/exgin"
)

var (
	FoundDomainCount = prometheus.NewCounter(prometheus.CounterOpts{
		Name: "default_backend_not_exist_domain",
		Help: "访问ingress default backend",
	})
)

func init() {
	prometheus.MustRegister(FoundDomainCount)
}

func main() {
	r := exgin.ExGin(false)
	// Example ping request.
	r.GET("/healthz", func(c *gin.Context) {
		exgin.GinsData(c, "pong "+fmt.Sprint(time.Now().Unix()), nil)
	})
	r.GET("/health", func(c *gin.Context) {
		exgin.GinsData(c, "pong "+fmt.Sprint(time.Now().Unix()), nil)
	})

	// Example / request.
	r.GET("/", func(c *gin.Context) {
		FoundDomainCount.Inc()
		exgin.GinsData(c, map[string]interface{}{
			"message": "default backend",
			"method":  c.Request.Method,
			"url":     c.Request.Host,
			"client":  c.ClientIP(),
			"ua":      c.Request.UserAgent(),
		}, nil)
	})

	// Example /metrics
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// Listen and Server in 0.0.0.0:8080
	r.Run(":8080")
}
