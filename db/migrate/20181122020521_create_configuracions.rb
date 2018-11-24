class CreateConfiguracions < ActiveRecord::Migration[5.0]
  def change
    create_table :configuracions do |t|
      t.string :telefono, limit: 50

      t.timestamps
    end
  end
end
