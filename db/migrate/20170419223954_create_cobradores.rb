class CreateCobradores < ActiveRecord::Migration[5.0]
  def change
    create_table :cobradores do |t|
      t.string :identidad, limit: 16
      t.string :nombre, limit: 35

      t.timestamps
    end
  end
end
