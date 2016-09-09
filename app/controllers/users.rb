class BookMark < Sinatra::Base

  get '/users/new' do
    @error_msg = flash[:notice]
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

  get '/users/password_reset' do
    #check token = token and time < time(0)+1hr
    #allow to enter new password
    erb :'users/password_reset'
  end

  post '/users/password_reset' do
    #store new password
    redirect '/links'
  end

end
