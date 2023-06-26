class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :invite_digest

      t.timestamps
    end
  end
end
