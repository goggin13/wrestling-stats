class Etoh::DrinksController < Etoh::ApplicationController
  def index
    @drink = Etoh::Drink.new
    @presenter = Etoh::DrinksPresenter.new
  end

  def create
    Etoh::Drink.create!(drink_params)
    redirect_to etoh_drinks_path
  end

  def destroy
    Etoh::Drink.find(params[:id]).destroy
    redirect_to etoh_drinks_path
  end

  def drink_params
    raw_consumed_at = params[:etoh_drink][:consumed_at]
    if raw_consumed_at.present?
      params[:etoh_drink][:consumed_at] = Time.now.advance(minutes: raw_consumed_at.to_i)
    end

    params.require(:etoh_drink).permit(:consumed_at)
  end
end
