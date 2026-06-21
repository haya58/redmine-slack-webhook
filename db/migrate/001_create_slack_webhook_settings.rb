class CreateSlackWebhookSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :slack_webhook_settings do |t|
      t.integer :project_id, null: false
      t.string :webhook_url
      t.boolean :enabled, default: true, null: false
      t.timestamps
    end

    add_index :slack_webhook_settings, :project_id, unique: true
  end
end
