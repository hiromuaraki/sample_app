class UsersController < ApplicationController
  
  #詳細ページ表示
  def show
    @user = User.find(params[:id])
    # debugger
  end
  
  #signup表示
  def new
    @user = User.new
  end
  
  #ユーザー登録
  def create
    @user = User.new(user_params)
    #保存に失敗したらリダイレクトしない
    return render 'new' unless @user.save
    #登録完了後、ログイン中に済みにする
    log_in @user
    flash[:success] = "Welcome to the Sample App!"
    redirect_to @user
  end
  
private
  #渡されたフォーム入力値の妥当性をチェック
  #初期化したハッシュを返す
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
