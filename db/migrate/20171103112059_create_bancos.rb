class CreateBancos < ActiveRecord::Migration[5.0]
  def change
    create_table :bancos do |t|
      t.string :banco

      t.timestamps
    end
  end
end
