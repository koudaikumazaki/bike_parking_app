# # == Schema Information
# #
# # Table name: contacts
# #
# #  id         :bigint           not null, primary key
# #  content    :text(65535)
# #  email      :string(191)
# #  genre      :string(191)
# #  name       :string(191)
# #  title      :string(191)
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #
# require 'rails_helper'

# RSpec.describe Contact, type: :model do

#   let(:contact) { create(:contact) }
#   it '各データが存在していればお問い合わせフォームが作られる' do
#     expect(contact).to be_valid
#   end

#   it 'nameが存在しない場合投稿が失敗する' do
#     contact.name = nil
#     contact.valid?
#     expect(contact.errors[:name]).to include("を入力してください")
#   end

#   it 'nameが31文字以上の場合投稿が失敗する' do
#     contact.name = 'a' * 31
#     contact.valid?
#     expect(contact.errors[:name]).to inclede('は30文字以内で入力してください')
#   end

#   it 'nameが30文字以下の場合投稿が成功する' do
#     contact.name = 'a' * 30
#     expect(contact).to be_valid
#   end

#   it 'emailが存在しない場合投稿が失敗する' do
#     contact.email = nil
#     contact.valid?
#     expect(contact.errors[:email]).to include("を入力してください")
#   end

#   it 'emailが101文字以上の場合投稿が失敗する' do
#     contact.email = "#{'a' * 89}@example.com"
#     contact.valid?
#     expect(user.errors[:email]).to include("は100文字以内で入力してください")
#   end

#   it 'emailが100文字以下の場合投稿が成功する' do
#     contact.email = "#{'a' * 88}@example.com"
#     expect(contact).to be_valid
#   end

#   it 'emailは全て小文字で保存される' do
#     contact.email = 'TESTER@EXAMPLE.COM'
#     contact.save!
#     expect(contact.reload.email).to eq 'tester@example.com'
#   end

#   it 'emailが正しいフォーマットで入力されていることを確認する' do
#     addresses = %w[user@foo,com
#       user_at_foo.org
#       example.user@foo.foo@bar_baz.com
#       foo@bar+baz.com
#       foo@bar..com]

#       addresses.each do |invalid_address|
#         expect(build(:contact, email: invalid_address)).to be_invalid
#       end
#   end

#   it "emailが重複していれば無効な状態である" do
#     create(:contact, email: "tester@example.com")
#     contact = build(:contact, email: "tester@example.com")
#     contact.valid?
#     expect(contact.errors[:email]).to include("はすでに存在します")
#   end

#   it 'genruが存在しない場合投稿が失敗する' do
#     contact.genru = nil
#     contact.valid?
#     expect(contact.errors[:genru]).to include("を入力してください")
#   end

#   it 'titleが存在しない場合投稿が失敗する' do
#     contact.title = nil
#     contact.valid?
#     expect(contact.errors[:title]).to include("を入力してください")
#   end

#   it 'titleが50文字以下の場合投稿が成功する' do
#     contact.title = 'a' * 50
#     expect(contact).to be_valid
#   end

#   it 'titleが51文字以上の場合投稿が失敗する' do
#     contact.title = 'a' * 51
#     contact.valid?
#     expect(contact.errors[:title]).to inclede('は50文字以内で入力してください')
#   end

#   it 'contentが存在しない場合投稿が失敗する' do
#     contact.content = nil
#     contact.valid?
#     expect(contact.errors[:content]).to include("を入力してください")
#   end

#   it 'contentが500文字以内の場合投稿が成功する' do
#     contact.content= 'a' * 500
#     expect(contact).to be_valid
#   end

#   it 'contentが501文字以上の場合投稿が失敗する' do
#     contact.content = 'a' * 501
#     contact.valid?
#     expect(contact.errors[:content]).to inclede('は500文字以内で入力してください')
#   end
# end
