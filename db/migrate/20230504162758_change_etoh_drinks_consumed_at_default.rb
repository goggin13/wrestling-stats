class ChangeEtohDrinksConsumedAtDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :etoh_drinks, :consumed_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
