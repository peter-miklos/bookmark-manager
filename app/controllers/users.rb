class BookMark < Sinatra::Base

  get '/users/new' do
    @current_email = session[:user_email]
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    session[:user_id] = user.id
    session[:user_email] = params[:email]
    if user.save
      redirect '/links'
    else
      flash[:notice] = user.errors.full_messages.join(", ")
      redirect '/users/new'
    end
  end

  get '/users/reset' do
    erb :'users/reset'
  end

  post '/users/reset' do
    user = User.first(email: params[:email])
    if user
      user.generate_token
    end
    # erb :'users/acknowledgement'
    flash[:notice] = "Please check your inbox"
    redirect '/links'
  end

  get '/users/password_recover' do
    erb :'users/password_recover'
  end

  post '/users/password_recover' do
    user = User.first(email: params[:email])
    user.generate_token if user
    erb :'/users/aknowledgement'
  end

  get "/users/password_reset" do
    @user = User.find_by_valid_token(params[:token])
    if @user
      session[:token] = params[:token]
      erb :"/users/password_reset"
    else
      "Your token is invalid"
    end
  end

  patch "/users" do
    user = User.find_by_valid_token(session[:token])
    if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      session[:token] = nil
      user.update(password_token: nil)
      redirect "/sessions/new"
    else
      flash.now[:errors] = user.errors.full_messages
      erb :'users/password_reset'
    end
  end
end
