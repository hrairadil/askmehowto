require 'rails_helper'
require 'shoulda-matchers'

describe Vote do
  it { should respond_to :value }
  it { should belong_to :user }
  it { should belong_to :votable }
end
