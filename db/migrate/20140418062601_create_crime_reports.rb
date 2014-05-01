class CreateCrimeReports < ActiveRecord::Migration
  def change
    create_table :crime_reports do |t|
      t.string :user
      t.text :body
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
