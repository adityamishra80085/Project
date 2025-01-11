# Gemfile
# Add necessary gems
ruby '3.2.0'
gem 'rails', '~> 7.0'
gem 'pg'
gem 'devise'
gem 'pundit'
gem 'bootstrap'
gem 'kaminari'
gem 'bcrypt'

# Run bundle install after updating the Gemfile

# ---------------------------
# Generate User model with Devise
rails generate devise:install
rails generate devise User name:string address:text role:integer
# Role: 0 - system_admin, 1 - normal_user, 2 - store_owner
rails db:migrate

# Add enum for User roles in the model
# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum role: { system_admin: 0, normal_user: 1, store_owner: 2 }

  validates :name, presence: true, length: { minimum: 20, maximum: 60 }
  validates :address, presence: true, length: { maximum: 400 }
  validates :password, length: { in: 8..16 }, format: { with: /(?=.*[A-Z])(?=.*[!@#$&*])/, message: 'must contain at least one uppercase letter and one special character' }
end

# ---------------------------
# Generate Store model
rails generate model Store name:string email:string address:text average_rating:float
rails db:migrate

# Add validations to the model
# app/models/store.rb
class Store < ApplicationRecord
  validates :name, presence: true, length: { maximum: 60 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true, length: { maximum: 400 }

  has_many :ratings, dependent: :destroy
end

# ---------------------------
# Generate Rating model
rails generate model Rating user:references store:references rating:integer
rails db:migrate

# Add validations and associations
# app/models/rating.rb
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates :rating, presence: true, inclusion: { in: 1..5 }
end

# ---------------------------
# Admin namespace for controllers
rails generate controller Admin::Dashboard
rails generate controller Admin::Users
rails generate controller Admin::Stores

# Normal user controllers
rails generate controller Users::Stores
rails generate controller Users::Ratings

# Store owner controllers
rails generate controller StoreOwner::Dashboard

# ---------------------------
# Routes
# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users
    resources :stores
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :users do
    resources :stores, only: [:index] do
      resources :ratings, only: [:create, :update]
    end
  end

  namespace :store_owner do
    get 'dashboard', to: 'dashboard#index'
  end

  root 'users/stores#index'
end

# ---------------------------
# Example Admin Dashboard Controller
# app/controllers/admin/dashboard_controller.rb
class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @total_users = User.count
    @total_stores = Store.count
    @total_ratings = Rating.count
  end

  private

  def authorize_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user.system_admin?
  end
end

# ---------------------------
# Example User Store Controller
# app/controllers/users/stores_controller.rb
class Users::StoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @stores = Store.includes(:ratings).page(params[:page]).per(10)
  end
end

# ---------------------------
# Example Store Owner Dashboard Controller
# app/controllers/store_owner/dashboard_controller.rb
class StoreOwner::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_store_owner

  def index
    @my_store = Store.find_by(email: current_user.email)
    @ratings = @my_store.ratings.includes(:user)
    @average_rating = @ratings.average(:rating)
  end

  private

  def authorize_store_owner
    redirect_to root_path, alert: 'Not authorized' unless current_user.store_owner?
  end
end

# ---------------------------
# Pagination with Kaminari
# app/views/users/stores/index.html.erb
<%= paginate @stores %>
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Address</th>
      <th>Average Rating</th>
    </tr>
  </thead>
  <tbody>
    <% @stores.each do |store| %>
      <tr>
        <td><%= store.name %></td>
        <td><%= store.address %></td>
        <td><%= store.average_rating || 'N/A' %></td>
      </tr>
    <% end %>
  </tbody>
</table>
<%= paginate @stores %>

# ---------------------------
# Additional controllers and views can be created similarly based on functionality.
