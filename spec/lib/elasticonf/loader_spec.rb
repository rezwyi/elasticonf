require 'spec_helper'

describe ElastiConf::Loader do
  it 'should be inherited from Hashie::Mash' do
    subject.should be_kind_of(Hashie::Mash)
  end
end