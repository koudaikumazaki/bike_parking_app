require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let(:user) { create(:user) }
  let!(:parking) { create(:parking, user_id: user.id) }
  describe '検索機能の確認', js:true do
    context 'ログインしたとき' do
      before do
        user.confirm
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end
      it 'トップページに検索フォームが表示されている' do
        visit '/'
        expect(page).to have_selector 'form'
      end
      context '検索フォームに文字が入っているとき' do
        context '検索に引っ掛かった場合' do
          it '検索結果が表示される' do
            fill_in 'parking[location]', with: '東京駅'
            click_button '検索'
            expect(current_path).to eq search_path
            expect(page).to have_content '検索結果が見つかりました。'
          end
        end
        context '検索に引っかからなかった場合' do
          it '検索結果はなかったとメッセージが表示される' do
            fill_in 'parking[location]', with: '北海道'
            click_button '検索'
            expect(current_path).to eq search_path
            expect(page).to have_content '検索結果は見つかりませんでした。'
          end
        end
      end
      context '検索フォームに文字が入っていないとき' do
        it 'ホーム画面にリダイレクトされる' do
          fill_in 'parking[location]', with: ''
          click_button '検索'
          redirect_to root_path
        end
      end
    end
    context 'ログインしていないとき' do
      it 'サインイン画面にリダイレクトされる' do
        visit '/search'
        redirect_to root_path
      end
    end
  end
end