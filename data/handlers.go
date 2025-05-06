package main

import (
	"encoding/json"
	"net/http"
	"github.com/go-chi/chi/v5"
)

func GetDoc(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	doc, err := GetFromCouch(id)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	json.NewEncoder(w).Encode(doc)
}

func CreateDoc(w http.ResponseWriter, r *http.Request) {
	var doc map[string]interface{}
	json.NewDecoder(r.Body).Decode(&doc)
	err := SaveToCouch(doc)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	w.WriteHeader(http.StatusCreated)
}

func UpdateDoc(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	var doc map[string]interface{}
	json.NewDecoder(r.Body).Decode(&doc)
	err := UpdateInCouch(id, doc)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func DeleteDoc(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	err := DeleteFromCouch(id)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	w.WriteHeader(http.StatusOK)
}
