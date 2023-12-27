# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Keywords", type: :system do
  let(:user) { create(:user) }
  let!(:keyword) { create(:keyword, user: user, word: '既存のキーワード') }

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
    visit keywords_path
  end

  describe "キーワードの追加" do
    context "有効なキーワードを入力した場合" do
      it "キーワードを追加できる" do
        fill_in 'キーワード', with: 'テストキーワード'
        click_button '追加する'
        expect(page).to have_content('キーワードが追加されました。トップページに戻ってみましょう。')
        expect(page).to have_content('テストキーワード')
      end
    end

    context "キーワード数が上限に達した場合" do
      it "キーワードをこれ以上追加できない" do
        3.times do |i|
          fill_in 'キーワード', with: "テストキーワード#{i}"
          click_button '追加する'
        end
        fill_in 'キーワード', with: '4つ目のキーワード'
        click_button '追加する'
        expect(page).to have_content('キーワードは3つまで登録できます。')
      end
    end

    context "無効なキーワード（空欄）を入力した場合" do
      it "キーワードを追加できない" do
        fill_in 'キーワード', with: ''
        click_button '追加する'
        expect(page).to have_content('キーワードを入力してください。')
      end
    end
  end
  describe 'キーワードの削除' do
    it 'ユーザーが自分のキーワードを削除できる' do
      visit keywords_path
      find('.btn.btn-outline-danger').click
      expect(page).not_to have_content 'テストキーワード'
    end
  end
end
