require 'spec_helper'

module FeatureHelpers
  def login
    user = FactoryGirl.create(:user)
    visit "/users/sign_in"
    within("form.new_user") do
      fill_in "Email", with: user.email
      fill_in "Password", with: "changeme"
      click_button "Sign in"
    end
    expect(page).to have_text("Signed in successfully")
  end
end
