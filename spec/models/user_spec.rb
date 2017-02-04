require 'rails_helper'

describe User do
  subject { build(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password) }
end
