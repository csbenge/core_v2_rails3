class AddAuthTokenToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :wrk_auth_token,  :string
  end
end
