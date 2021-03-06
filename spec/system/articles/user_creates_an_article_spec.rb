require "rails_helper"

RSpec.describe "Creating an article with the editor", type: :system do
  include_context "with runkit_tag"

  let(:user) { create(:user) }
  let!(:template) { file_fixture("article_published.txt").read }
  let!(:template_with_runkit_tag) do
    file_fixture("article_with_runkit_tag.txt").read
  end

  before do
    sign_in user
  end

  it "creates a new article", js: true, retry: 3 do
    visit new_path
    fill_in "article_body_markdown", with: template
    click_button "SAVE CHANGES"
    expect(page).to have_selector("header h1", text: "Sample Article")
  end

  context "with Runkit tag", js: true do
    it "creates a new article with a Runkit tag" do
      visit new_path
      fill_in "article_body_markdown", with: template_with_runkit_tag
      click_button "SAVE CHANGES"

      expect_runkit_tag_to_be_active
    end

    it "previews article with a Runkit tag and creates it" do
      visit new_path
      fill_in "article_body_markdown", with: template_with_runkit_tag
      click_button "PREVIEW"

      expect_runkit_tag_to_be_active

      click_button "EDIT"

      expect_no_runkit_tag_to_be_active

      click_button "SAVE CHANGES"

      expect_runkit_tag_to_be_active
    end
  end
end
