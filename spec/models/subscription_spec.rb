require 'rails_helper'
require 'shoulda-matchers'

describe Subscription do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
end
