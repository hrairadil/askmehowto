require 'rails_helper'

RSpec.describe User do
  let(:user) { create :user }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
end