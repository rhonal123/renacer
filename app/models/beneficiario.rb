class Beneficiario < ApplicationRecord
	##ABUELO PADRE HERMANO NIETO OTROS 
  belongs_to :contrato , inverse_of: :beneficiarios

  def nombre_corto
    _nombre = self.nombres.split()[0]
    _apellido = self.apellidos.split()[0]
    "#{_nombre} #{_apellido}"
  end 


  validates :identidad, 
    presence: {message: 'Ingrese Rif ó cedula de identidad '},
    #uniqueness: {message: 'Identidad Registrada ', on: :create },
    length: {maximum: 16 , too_long:"%{count} caracteres es el maximo  "}
    
  validates :nombres,
    presence: {message: 'Ingrese.'},
    length: {maximum: 180, too_long:"%{count} caracteres es el maximo  "}

  validates :apellidos,
    presence: {message: 'Ingrese.'},
    length: {maximum: 120, too_long:"%{count} caracteres es el maximo  "}
    
  validates :fechaNacimiento, presence: {message: 'Ingrese.'}
  validates :contrato, presence: {message: 'Ingrese.'}
  validates :parentesco, presence: {message: 'Ingrese.'}

end
