require 'rails_helper'

RSpec.describe PasswordResetsHelper, type: :helper do
    it "masks email correctly" do
        expect(helper.masked_email("sisi@example.com")).to eq("s***i@example.com")
    end
end
