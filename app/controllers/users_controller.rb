class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only:[:destroy]
  #詳細ページ表示
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated? 
    # debugger
  end
  
  #ユーザー一覧表示
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  #signup表示
  def new
    @user = User.new
  end
  
  #ユーザー登録
  def create
    @user = User.new(user_params)
    #保存に失敗したらリダイレクトしない
    if @user.save
      #ログイン済みにする
      log_in @user
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    end
  end
  
  #編集ページ
  def edit
    @user = User.find(params[:id])
  end
  
  #編集の実行
  def update
    @user = User.find(params[:id])
    if @user&.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  #削除実行
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
private
  #渡されたフォーム入力値の妥当性をチェック
  #初期化したハッシュを返す
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  # beforeアクション----------
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
    
  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
    
end
