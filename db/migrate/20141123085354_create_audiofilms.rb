class CreateAudiofilms < ActiveRecord::Migration
  def change
    create_table :audiofilms do |t|
      t.string :title
      t.text :description
      t.date :release
      t.string :slug

      t.timestamps
    end
  end
end
