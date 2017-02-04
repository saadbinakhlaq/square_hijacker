require 'rails_helper'

describe Square do
  it { is_expected.to validate_uniqueness_of(:number) }
  it { is_expected.to validate_presence_of(:number) }
end
