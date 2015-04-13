require 'rails_helper'
require 'shoulda-matchers'

describe Vote do
  it { should respond_to :value }

  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

end
