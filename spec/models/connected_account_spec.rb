require 'rails_helper'

RSpec.describe ConnectedAccount, type: :model do
    describe "ConnectedAccount" do
      let(:invalid_attributes) { { state: nil } }
  
      context "list" do
        it "returns all connected accounts" do
          connected_account = FactoryBot.create(:connected_account)
          expect(ConnectedAccount.all).to eq([connected_account])
        end
      end
  
      context "get!" do
        it "returns the connected account with given id" do
          connected_account = FactoryBot.create(:connected_account)
          expect(ConnectedAccount.find(connected_account.id)).to eq(connected_account)
        end
      end
  
      context "create" do
        it "with valid data creates a connected account" do
          valid_attributes = { state: "some state" }
          connected_account = ConnectedAccount.create(valid_attributes)
          expect(connected_account.state).to eq("some state")
        end
  
        it "with invalid data returns error" do
          connected_account = ConnectedAccount.new(invalid_attributes)
          expect(connected_account.valid?).to be_falsey
          expect(connected_account.errors).to be_present
        end
      end
  
      context "update" do
        it "with valid data updates the connected account" do
          connected_account = FactoryBot.create(:connected_account)
          update_attributes = { state: "some updated state" }
          connected_account.update(update_attributes)
          expect(connected_account.state).to eq("some updated state")
        end
  
        it "with invalid data does not update connected account" do
          connected_account = FactoryBot.create(:connected_account)
          connected_account.update(invalid_attributes)
          expect(connected_account.reload.attributes).not_to include(invalid_attributes.stringify_keys)
        end
      end
  
      context "delete" do
        it "deletes the connected account" do
          connected_account = FactoryBot.create(:connected_account)
          expect { connected_account.destroy }.to change(ConnectedAccount, :count).by(-1)
        end
      end
  
      context "change" do
        it "returns a connected account changeset" do
          connected_account = FactoryBot.create(:connected_account)
          expect(connected_account).to be_valid
        end
      end
    end
  end