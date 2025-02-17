# **Pizza Factory** 🍕  
_A vendor-based inventory management system for handling pizzas, toppings, orders, and inventory._

---

## **📖 Table of Contents**  
- [📌 About the Project](#about-the-project)  
- [🛠️ Technologies Used](#technologies-used)  
- [⚙️ System Requirements](#system-requirements)  
- [🚀 Installation & Setup](#installation--setup)  
- [📂 Project Structure](#project-structure)  
- [▶️ Running the Application](#running-the-application)  
- [🧪 Testing](#testing)  
- [🔐 Credentials & Security](#credentials--security)  
- [📑 Documentation](#documentation)  
- [📖 Future Enhancements](#future-enhancements)  
- [📬 Contact & Support](#contact--support)  

---

## **📌 About the Project**  
<a id="about-the-project"></a>
Pizza Factory is a vendor-based inventory management system that allows vendors to manage:  
✅ **Pizzas** (Categories, Prices, etc.)  
✅ **Toppings**  
✅ **Orders** (Confirmation, Details, etc.)  
✅ **Inventory Management**  

It ensures smooth order processing with proper authentication and inventory tracking.  

---

## **🛠️ Technologies Used**  
<a id="technologies-used"></a>

- **Ruby on Rails** (Framework)  
- **PostgreSQL** (Database)  
- **RSpec** (Testing)  
- **TailwindCSS** (Frontend Styling)  
- **Yarn** (Package Management)  

---

## **⚙️ System Requirements**  
<a id="system-requirements"></a>

Ensure your system has the following:  
- **Ruby**: `3.2.0`  
- **Rails**: `8.x`  
- **PostgreSQL**: `16+`  
- **Node.js** & **Yarn**  
- **Bundler** (`gem install bundler`)  

---

## **🚀 Installation & Setup**  
<a id="installation--setup"></a>

1️⃣ Clone the Repository
```sh
git clone https://github.com/your-username/pizza_factory.git
cd pizza_factory
```
2️⃣ Install Dependencies
```sh
bundle install
yarn install
```
3️⃣ Setup Database
```sh
rails db:create
rails db:migrate
rails db:seed
```
4️⃣ Configure Credentials

🔑 Creating Development & Test Credential Keys
- Generate & Store the Development Key
`echo "17ee4f1843a8ee648f83210cdd3f0ebf" > config/credentials/development.key`
- Generate & Store the Test Key
`echo "fe30d94cbaedfbd3b8b317d5c390b9c4" > config/credentials/test.key`
`

Edit Rails encrypted credentials for development & test environments:
```sh
EDITOR=nano rails credentials:edit --environment development
EDITOR=nano rails credentials:edit --environment test
```
```
Add the following:
vendors:
  authentication:
    username: "vendor"
    password: "secure_password"
```
5️⃣ Start the Server
```sh
rails server
Visit: http://localhost:3000
```

## **📂 Project Structure**  
<a id="project-structure"></a>

```
app/
 ├── controllers/
 │    ├── vendors/
 │    │    ├── inventories_controller.rb
 │    │    ├── orders_controller.rb
 │    │    ├── pizzas_controller.rb
 │    │    ├── toppings_controller.rb
 ├── models/
 │    ├── inventory.rb
 │    ├── order.rb
 │    ├── pizza.rb
 │    ├── topping.rb
 ├── views/
 │    ├── vendors/
 │    │    ├── inventories/
 │    │    ├── orders/
 │    │    ├── pizzas/
 │    │    ├── toppings/
 ├── spec/
 │    ├── controllers/
 │    ├── models/
```

## **▶️ Running the Application**
<a id="running-the-application"></a>

✅ Start the Rails Server
```sh
rails s
```
## **🧪 Testing**
<a id="testing"></a>

✅ Run All Tests
```sh
rspec
```
✅ Run Specific Test
```sh
rspec spec/controllers/vendors/crusts_controller_spec.rb
```

## **🔐 Credentials & Security**
<a id="credentials--security"></a>

Fetching Credentials Securely in Code
```sh
vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
```

📌 Authentication
Authenticate vendors securely using credentials.

```sh
if params[:username] == vendor_username && params[:password] == vendor_password
  puts "✅ Authentication successful!"
else
  puts "❌ Invalid credentials!"
end
```

## **📑 Documentation**
<a id="documentation"></a>

📚 Vendors::InventoriesController

_Handles inventory listing & updates.

- GET /vendors/inventories → Lists all inventories

- PATCH /vendors/inventories/:id → Updates inventory quantity


📚 Vendors::OrdersController

_Manages orders & confirmation.

- GET /vendors/orders → Lists all orders

- GET /vendors/orders/:id → Shows order details

- PATCH /vendors/orders/:id/confirm → Confirms an order


📚 Vendors::PizzasController

_Handles pizza management.

- GET /vendors/pizzas → Lists all pizzas

- GET /vendors/pizzas/new → New pizza form

- POST /vendors/pizzas → Creates a new pizza


📚 Vendors::ToppingsController

_Handles toppings management.

- GET /vendors/toppings → Lists all toppings

- GET /vendors/toppings/new → New topping form

- POST /vendors/toppings → Creates a new topping


## **📖 Future Enhancements**
<a id="future-enhancements"></a>

- Move Rails views to React for a better frontend experience

- Create API endpoints to serve data efficiently

- Add API versioning for better maintainability

- Improve authentication with JWT

- Add GraphQL support for flexible data queries


## **📬 Contact & Support**
<a id="contact--support"></a>

For any issues, reach out via:

  📧 Email: larebindore@gmail.com

  📌 GitHub Issues: Open an Issue