class PagarValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:estado,"El contrado debe estar activo") unless record.contrato.activo?
    record.errors.add(:estado,"El pago debe estar pendiente") unless record.pendiente?
    record.errors.empty?
  end
end