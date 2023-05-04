class ChangeEtohDrinksAbvDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :etoh_drinks, :abv, 5
    change_column_default :etoh_drinks, :oz, 12
  end
end
