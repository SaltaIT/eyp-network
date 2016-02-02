require 'spec_helper'
describe 'network' do

  context 'with defaults for all parameters' do
    it { should contain_class('network') }
  end
end
