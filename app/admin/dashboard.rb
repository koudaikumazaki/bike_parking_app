ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "未承認の駐輪場" do
          table_for Parking.where(approval: false).order("created_at desc").limit(10) do
            column("駐輪場名") { |parking| link_to(parking.name, admin_parking_path(parking.id)) }
            column("投稿者名") { |parking| link_to(parking.user.email, admin_user_path(parking.user)) }
            column('承認ステータス') { |parking| parking.approval } 
            column() { |parking| link_to('承認する', edit_admin_parking_path(parking.id)) }
          end
        end
      end
    end
  end
end
