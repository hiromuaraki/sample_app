class SessionsController < ApplicationController
  
  #ログインページ表示
  def new
  end
  
  #ログイン
  def create
    #Usersテーブルよりemailにて存在チェック
    user = User.find_by(email:params[:session][:email].downcase)
    #入力されたユーザーがDBに存在し、かつ認証に成功か：失敗したらレンダリングしない
    if user && user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
         #chek_box ON:1 OFF:0
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new' 
    end
    
  end
  
  #ログアウト
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
