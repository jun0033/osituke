class Public::HomesController < ApplicationController
  def top
    @hobbies = Hobby.all
  end
end
