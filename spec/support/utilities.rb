include ApplicationHelper

#Helpers for Authentication
def valid_sign_in(user)
	visit signin_path     #technically redundant when nested on the auth page, but needed for later cases.
	fill_in "Email", 		with: user.email
	fill_in "Password",		with: user.password
	click_button "Sign in"
    #sign in when not using capybara as well
    cookies[:remember_token] = user.remember_token

end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

#Helpers for User Specs
def dummy_signup
	fill_in "Name", 	with: "Example User"
	fill_in "Email", 	with: "username@example.com"
	fill_in "Password", with: "foobar"
	fill_in "Confirmation", with: "foobar"
end

def make_dummy_user
	let(:user) { FactoryGirl.create(:user) }
end

def make_user(identity)
		sanitize = identity.downcase 
		FactoryGirl.create(:user, name: identity, email: "#{sanitize}@example.com")
end