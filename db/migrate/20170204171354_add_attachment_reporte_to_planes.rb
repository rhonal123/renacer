class AddAttachmentReporteToPlanes < ActiveRecord::Migration
  def self.up
    change_table :planes do |t|
      t.attachment :reporte
    end
  end

  def self.down
    remove_attachment :planes, :reporte
  end
end
