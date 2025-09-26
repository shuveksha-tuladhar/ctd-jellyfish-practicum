# 💸 CostShare

**CostShare** is a full-stack web application designed to help users split and manage shared expenses with friends or groups — perfect for roommates, trips, or any shared activity.

Users can **create an account, add friends**, form **groups**, log **expenses** by category, and track who owes whom with a clear, organized balance view. Inspired by apps like Splitwise, CostShare simplifies financial coordination among multiple people.

---

## 📚 Table of Contents

- [Description](#description)
- [Team](#team)
- [Demo](#demo)
- [Technology](#technology)
- [Routes](#routes)
- [Security](#security)
- [Project Setup & Development](#project-setup--development)

---

<h2 id="user-content-description">📝 Description</h2>

CostShare simplifies financial coordination among multiple people. Users can:

- Create an account and securely log in
- Add and manage friends
- Form groups for shared expenses
- Log and categorize expenses
- Automatically split costs
- View detailed balances showing who owes whom

### ✅ Key Features

- 👤 **User Authentication** (Register, Login, Logout)
- 🧑‍🤝‍🧑 **Friend Management** (Add, search, unfriend)
- 👥 **Group Creation** for shared expenses
- 💰 **Expense Tracking** with categories
- 📊 **Balance Overview** (owed and owing summaries)
- 🔄 **Split Expenses** equally among group members
- 🧭 **Responsive UI** with reusable navbar and sidebar
- 🛠️ Built with **Ruby on Rails**, **PostgreSQL**, **HTML**, and **CSS**

---

<h2 id="user-content-team">👥 Team Members</h2>

- Shuveksha Tuladhar
- Abraham Flores
- Sisi Wang

---

<h2 id="user-content-demo">🎥 Demo</h2>

> Coming soon — add a link to your deployed app or video walkthrough here.

---

<h2 id="user-content-technology">🛠️ Technology</h2>

- **Frontend:** HTML, CSS, ERB (Embedded Ruby)
- **Backend:** Ruby on Rails
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Version Control:** Git & GitHub
- **Project Management:** Jira, Slack
- **Design & Planning:** Miro (Wireframes), ER Diagrams

---

<h2 id="user-content-routes">🌐 Routes</h2>

| HTTP Verb | Path                        | Controller#Action        | Description                          |
|-----------|-----------------------------|-------------------------|------------------------------------|
| GET       | /                           | home#index              | Home page                          |
| GET       | /login                      | sessions#new            | Login form                        |
| POST      | /login                      | sessions#create         | Submit login                     |
| DELETE    | /logout                     | sessions#destroy        | Logout                          |
| GET       | /signup                     | users#new               | Signup form                     |
| POST      | /users                      | users#create            | Create new user                 |
| GET       | /users                      | users#index             | List all users                  |
| GET       | /users/:id                  | users#show              | Show user profile              |
| GET       | /users/:id/edit             | users#edit              | Edit user profile              |
| PATCH     | /users/:id                  | users#update            | Update user profile            |
| DELETE    | /users/:id                  | users#destroy           | Delete user                   |
| GET       | /users/:id/edit_password    | users#edit_password     | Edit user password            |
| PATCH     | /users/:id/update_password  | users#update_password   | Update user password          |
| GET       | /users/:id/upload_photo     | users#upload_photo      | Upload user photo             |
| PATCH     | /users/:id/upload_photo     | users#upload_photo      | Submit user photo upload      |
| RESTful   | /users/:user_id/friendships | friendships#*           | Manage friendships            |
| RESTful   | /users/:user_id/payments    | payments#*              | Manage payments               |
| GET       | /users/:user_id/balances    | balances#index          | Show user balances            |
| RESTful   | /expenses                   | expenses#*              | Manage expenses               |
| RESTful   | /user_groups                | user_groups#*           | Manage user groups            |
| RESTful   | /user_groups/:user_group_id/group_members | group_members#* | Manage group members       |
| GET       | /dashboard                  | dashboard#index         | Dashboard overview            |
| GET       | /password_resets/new        | password_resets#new     | Password reset request form   |
| POST      | /password_resets            | password_resets#create  | Send password reset email     |
| GET       | /password_resets/:token/edit | password_resets#edit   | Password reset form           |
| PATCH     | /password_resets/:token     | password_resets#update  | Update password               |
| GET       | /up                         | rails/health#show       | Health check endpoint         |

---

<h2 id="user-content-security">🔐 Security</h2>

- User passwords are securely stored using bcrypt with has_secure_password
- Users can register, log in, and log out safely with session management
- Only logged-in users can access protected parts of the app
- Validations ensure emails and phone numbers are unique and properly formatted
- Profile pictures are handled safely with Active Storage
---

<h2 id="user-content-project-setup--development">⚙️ Project Setup & Development</h2>

### 🔢 Ruby Version

- **Ruby:** `3.2.0` 
- **Rails:** `8.0.3`

---

### 📦 System Dependencies

Make sure the following are installed:

- Ruby
- Rails
- PostgreSQL
- Bundler

---

### ⚙️ Configuration

After cloning the repository:

```
bundle install

```
### 🗃️ Database Creation
```
rails db:create
```
### 🧱 Database Initialization
```
rails db:migrate
```
### 🚀 Running the App
```
bin/rails s
```
Then open your browser and go to:
```
http://localhost:3000
```


