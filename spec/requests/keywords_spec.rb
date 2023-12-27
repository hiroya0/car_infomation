# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "キーワード", type: :request do
  let(:user) { create(:user) }
  let(:valid_word) { { word: 'テストキーワード' } }
  let(:invalid_word) { { word: '' } }

  before do
    sign_in user
  end

  describe "POST /keywords" do
    context "キーワードの入力が有効な場合" do
      it "新しいキーワードを作成する" do
        expect {
          post keywords_path, params: { keyword: valid_word }
        }.to change(Keyword, :count).by(1)
      end

      it "キーワード一覧にリダイレクトする" do
        post keywords_path, params: { keyword: valid_word }
        expect(response).to redirect_to(keywords_path)
      end
    end

    context "キーワードの上限を超えた場合" do
      before { 3.times { user.keywords.create!(valid_word) } }

      it "新しいキーワードを作成しない" do
        expect {
          post keywords_path, params: { keyword: valid_word }
        }.not_to change(Keyword, :count)
      end

      it "キーワード一覧にリダイレクトする" do
        post keywords_path, params: { keyword: valid_word }
        expect(response).to redirect_to(keywords_path)
      end
    end

    context "何も入力がされていない場合" do
      it "新しいキーワードを作成しない" do
        expect {
          post keywords_path, params: { keyword: invalid_word }
        }.not_to change(Keyword, :count)
      end

      it "キーワード一覧にリダイレクトする" do
        post keywords_path, params: { keyword: invalid_word }
        expect(response).to redirect_to(keywords_path)
      end
    end
  end
end
