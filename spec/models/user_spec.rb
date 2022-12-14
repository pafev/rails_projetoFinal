require 'rails_helper'

RSpec.describe User, type: :model do
  context "testing factory" do
    it { expect(build(:user)).to be_valid }
  end

  context "testing name" do
    it "name shouldn't be nil" do
      expect(build(:user, name: nil)).to be_invalid
    end
    it "name should be uniq" do
      create(:user, name: 'aa', email: 'example1@example')
      expect(build(:user, name: 'aa', email: 'example2@example')).to be_invalid
    end
  end

  context "testing email" do
    it "email shouldn't be nil" do
      expect(build(:user, email: nil)).to be_invalid
    end
    it "email should be uniq" do
      create(:user, name: 'aa')
      expect(build(:user, name: 'bb')).to be_invalid
    end
  end

  context "testing password" do
    it "password shouldn't be nil" do
      expect(build(:user, password: nil)).to be_invalid
    end
  end

  context "trait :admin is ok" do
     it {expect(build(:user, :admin).is_admin).to eq(true)}
  end
end
