class CreateBeneficiarios < ActiveRecord::Migration[5.0]
  def change
    create_table :beneficiarios do |t|
      t.string :identidad, limit: 16
      t.belongs_to :contrato, foreign_key: true
      t.string :apellidos,  limit: 120
      t.string :nombres,  limit: 120
      t.date :fechaNacimiento
      t.string :parentesco, limit: 10 # ABUELO PADRE HERMANO NIETO OTROS 
      t.timestamps
    end
  end
end
