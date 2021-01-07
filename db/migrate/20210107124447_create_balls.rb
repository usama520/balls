class CreateBalls < ActiveRecord::Migration[6.0]
  def change
    create_table :balls do |t|
      t.string :blue_ball
      t.string :red_ball
      t.string :imaginary_ball

      t.timestamps
    end
  end
end
