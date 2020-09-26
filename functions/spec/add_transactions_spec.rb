require_relative "../feat_trans_functions"

describe "add_single_trans" do
    it "it should add a single transaction to user CSV and return success message" do
        expect(add_single_trans("test")).to eq("Transaction added")
    end
end