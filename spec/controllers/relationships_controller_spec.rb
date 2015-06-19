require 'spec_helper'

# This is a controller rather than an integration test, because XZHR method is not available in other type.
# XHR takes [HTTP Method] , [SYymbol for action], hash with contents of Params
describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user)}

	before { valid_sign_in user}

	describe "create a relationship with AJAX" do
		it "should increment the relationship count" do
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.should change(Relationship, :count).by(1)
		end

		it "should respond with a success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			response.should be_success
		end
	end

	describe "destroying a relationship with AJAX" do
		before { user.follow!(other_user) }
		let(:relationship) { user.relationships.find_by_followed_id(other_user) }

		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.should change(Relationship, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			response.should be_success
		end
	end
end