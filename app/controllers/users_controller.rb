# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.order(:id).page(params[:page]).per(2)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end
end
