package main

import (
	"net/http"
	"github.com/go-chi/chi/v5"
)

func SetupRoutes() http.Handler {
	r := chi.NewRouter()

	r.Get("/data/{id}", GetDoc)
	r.Post("/data", CreateDoc)
	r.Put("/data/{id}", UpdateDoc)
	r.Delete("/data/{id}", DeleteDoc)

	return r
}
