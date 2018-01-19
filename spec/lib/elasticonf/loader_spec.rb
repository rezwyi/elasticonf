require 'spec_helper'

describe Elasticonf::Loader do
  subject do
    file = Elasticonf.root.join('spec', 'fixtures', 'config.yml')
    described_class[YAML.load_file(file)]
  end

  it 'should be inherited from Hashie::Mash' do
    expect(subject).to be_kind_of(Hashie::Mash)
  end

  describe '#get' do
    it 'should return nil' do
      expect(subject.get('some.unexisting.key')).to be_nil
    end

    it 'should return some value' do
      expect(subject.get('some_config.int_key')).to eql(1)
    end

    it 'should return some value' do
      expect(subject.get('some_config.str_key')).to eql('1')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.get }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.get({}) }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.get([]) }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.get(false) }.to raise_error(ArgumentError)
      end
    end
  end
end
