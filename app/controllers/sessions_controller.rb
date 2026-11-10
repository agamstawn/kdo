class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Terlalu banyak percobaan masuk. Coba lagi beberapa saat." }

  def new; end

  def create
    user = User.find_by(email_address: params[:email_address].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      start_session_for(user)
      redirect_to root_path, notice: "Berhasil masuk sebagai #{user.email_address}."
    else
      flash.now[:alert] = "Email atau kata sandi tidak valid."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    end_session
    redirect_to new_session_path, notice: "Anda telah keluar dari aplikasi."
  end
end
