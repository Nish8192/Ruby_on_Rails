class UsersController < ApplicationController
    def create
        user = User.create(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], location: params[:location], state: params[:state], password: params[:password], password_confirmation: params[:password_confirmation])
        if user.valid?
            session[:user_id] = user.id
            flash[:errors] = ["New User Successfully Created!"]
            redirect_to "/events"
        else
            flash[:errors] = user.errors.full_messages
            redirect_to "/"
        end
    end

    def show
        @in_state_events = Event.where(state: current_user.state)
        @other_events = Event.where.not(state: current_user.state)
        render "users/show.html.erb"
    end

    def edit
        render "users/edit.html.erb"
    end

    def update
        user = current_user
        user.first_name = params[:first_name]
        user.last_name = params[:last_name]
        user.email = params[:email]
        user.location = params[:location]
        user.state = params[:state]
        user.password = current_user.password_digest
        user.password_confirmation = current_user.password_digest
        user.save
        if user.valid?
            flash[:errors] = ["Information Successfully Changed!!"]
            redirect_to "/events"
        else
            flash[:errors] = user.errors.full_messages
            redirect_to "/users/#{user.id}/edit"
        end
    end
end
