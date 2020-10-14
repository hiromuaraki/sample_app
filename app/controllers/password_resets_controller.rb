class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :valid_suer, only:[:edit, :update]
  before_action :check_expiration, only:[:eidt, :update]
  
  #パスワード再設定画面
  def new
  end
  
  
  #パスワード再設定メールの送信
  def create
    #dbよりメールアドレスを条件にデータを取得
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    #ユーザーの存在チェック
    if @user
      #パスワードの再設定トークンの作成、トークン & タイムスタンプの更新
      @user.create_reset_digest
      #パスワード再設定用メールを送信
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  def edit
  end
  
  #パスワードの再設定の実行
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attribute(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  #beforeフィルタ---------
  
    # ユーザー存在チェック
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # 有効なユーザーかどうか確認する
    def valid_suer
      unless (@user && @user.activated? &&
        @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
    
    # 許可するパラメータチェック
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
