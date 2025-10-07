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
    add_index :members, "UPPER(member_id)", unique: true, name: "index_members_on_upper_member_id"
    add_index :members, "LOWER(email)", unique: true, name: "index_members_on_lower_email"
    add_index :members, "LOWER(name_last), LOWER(name_first)", name: "index_members_on_lower_name_last_and_first"
  end
end
