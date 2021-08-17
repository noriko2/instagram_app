class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
        # default: falseという引数を追加。
        # --デフォルトでは管理者になれないということを示すため
        # --（default: false引数を与えない場合、 adminの値はデフォルトでnilになるが、これはfalseと同じ意味のため、必ずこの引数を与える必要はない。ただし、このように明示的に引数を与えておけば、コードの意図をRailsと開発者に明確に示すことができる
    add_column :users, :admin, :boolean, default: false
  end
end
