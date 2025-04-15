package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

var db *sql.DB

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Database connection details
	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
	)

	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Failed to initialize database connection: %v", err)
	}

	http.HandleFunc("/check-db", checkDBHandler)
	log.Println("Server started on :8080")
	http.ListenAndServe(":8080", nil)
}

func checkDBHandler(w http.ResponseWriter, r *http.Request) {
	if err := db.Ping(); err != nil {
		response := map[string]bool{"success": true}
		json.NewEncoder(w).Encode(response)
		return
	}
	response := map[string]bool{"success": false}
	json.NewEncoder(w).Encode(response)
}
