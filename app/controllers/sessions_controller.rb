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
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new' 
    end
    
  end
  
  #ログアウト
  def destroy
    log_out
    redirect_to root_url
  end
end
