class StaticPagesController < ApplicationController
  def home
    if user_is_signed_in?
      redirect_to projects_path
    else
      render 'shared/home_when_not_signed_in'
    end
  end
end
