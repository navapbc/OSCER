class CreateMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members, id: :uuid do |t|
      t.string :member_id
      t.string :name_first
      t.string :name_middle
      t.string :name_last
      t.string :email

      t.timestamps
    end
  end
end
