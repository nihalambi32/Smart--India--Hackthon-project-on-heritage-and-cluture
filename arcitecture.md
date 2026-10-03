# 🏛️ Virasat – System Architecture

## 1. Overview

**Virasat – Roots & Radiance** is a digital heritage platform developed for **Smart India Hackathon 2026**.

The system is designed to showcase India's rich cultural heritage using:

* Cross-platform application development
* Geo-tagged heritage mapping
* AI-powered storytelling
* Interactive chatbot
* Bilingual voice assistance
* Heritage databases

**Problem Statement ID:** SIH26197
**Team ID:** G109
**Team Name:** Team Virasat

---

# 2. High-Level Architecture

```text
                    ┌─────────────────────────┐
                    │          USER           │
                    │   Tourist / Visitor     │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │    FLUTTER FRONTEND     │
                    │                         │
                    │ • Heritage Exploration  │
                    │ • Maps                   │
                    │ • Stories                │
                    │ • Chatbot                │
                    │ • Voice Assistant       │
                    └────────────┬────────────┘
                                 │
                                 │ API Requests
                                 ▼
              ┌─────────────────────────────────────┐
              │            BACKEND LAYER            │
              │                                     │
              │       Node.js + Python/FastAPI      │
              │                                     │
              │ • API Management                    │
              │ • User Requests                     │
              │ • Heritage Data                     │
              │ • AI Services                       │
              └───────────────┬─────────────────────┘
                              │
              ┌───────────────┼────────────────┐
              │               │                │
              ▼               ▼                ▼
     ┌────────────────┐ ┌──────────────┐ ┌─────────────────┐
     │   PostgreSQL   │ │   PostGIS    │ │   AI / NLP      │
     │    Database    │ │ Geo Database │ │   LLM Services  │
     └────────────────┘ └──────────────┘ └─────────────────┘
                              │                │
                              │                ▼
                              │       ┌─────────────────┐
                              │       │ AI Storytelling │
                              │       │ & Chatbot       │
                              │       └─────────────────┘
                              │
                              ▼
                    ┌─────────────────────────┐
                    │   HERITAGE INFORMATION │
                    │                         │
                    │ • Sites                 │
                    │ • Locations             │
                    │ • Cultural Stories      │
                    │ • Traditions            │
                    └─────────────────────────┘
```

---

# 3. Architecture Components

## 3.1 Frontend Layer

### Technology: Flutter

Flutter is used for developing the cross-platform application.

### Responsibilities

* Display heritage locations
* Show heritage information
* Provide interactive maps
* Display cultural stories
* Provide chatbot interface
* Provide voice-assistant interface
* Communicate with backend APIs

The SIH proposal specifies Flutter for cross-platform mobile and web application development.

---

# 4. Backend Layer

### Technologies

* Node.js
* Python
* FastAPI

The backend acts as the communication layer between the frontend, database, mapping system, and AI services.

### Responsibilities

```text
Frontend
   │
   ▼
Backend API
   │
   ├── User Requests
   ├── Heritage Data
   ├── Location Data
   ├── AI Requests
   └── Chatbot Requests
```

The proposed technical approach uses **Node.js and Python with FastAPI** for the server architecture.

---

# 5. Database Layer

## PostgreSQL

PostgreSQL is proposed as the main database.

It can store:

* Heritage site information
* Cultural information
* User-related data
* Location information
* Stories
* Other application data

## PostGIS

PostGIS is used with PostgreSQL for geographical and location-based heritage data.

### Example

```text
Heritage Site
      │
      ├── Name
      ├── Description
      ├─
```
