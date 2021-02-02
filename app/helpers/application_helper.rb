module ApplicationHelper
  #  # 表示名とパスを受け取る
  # def header_link_item(name, path)
  #   # bootstrapのnavbar-navの子クラスにしたいので、nav-itemをクラス名に指定
  #   class_name = 'nav-item'
  #   # ヘルパーメソッドの呼び出し。アクティブなページの場合、クラスにactiveの文言を追加してヘッダーの対象文字を活性化する
  #   class_name << ' active' if current_page?(path)

  #   # 任意のhtmlタグを作成するためのヘルパーメソッド
  #   content_tag :li, class: class_name do
  #       link_to name, path, class: 'nav-link'
  #   end
  # end
end
