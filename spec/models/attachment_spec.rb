require 'rails_helper'
require 'shoulda-matchers'

describe Attachment do
  it { should validate_presence_of :file }
  it { should belong_to :attachable }
end
