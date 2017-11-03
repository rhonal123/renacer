class AddCuentaIdToFormaDePago < ActiveRecord::Migration[5.0]
  def change
    add_reference :forma_pagos, :cuenta, foreign_key: true 
  end
end

