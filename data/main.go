package main

import (
	"log"
	"net/http"
)

func main() {
	r := SetupRoutes()

	log.Println("Starting server on :8080...")
	err := http.ListenAndServe(":8080", r)
	if err != nil {
		log.Fatalf("Server failed: %s", err)
	}
}
