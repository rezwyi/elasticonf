require 'spec_helper'

describe ElastiConf do
  it { should be_a(Module) }

  describe '#config_root' do
    it 'should raise an error' do
      expect { subject.config_root }.to raise_error
    end

    it 'should return some value' do
      subject.config_root = '/config'
      subject.config_root.should eql(Pathname.new('/config'))
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.config_root = -> {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.config_root = {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.config_root = [] }.to raise_error
      end
    end
  end

  describe '#const_name' do
    it 'should return default value' do
      expect(subject.const_name).to eql('Settings')
    end

    it 'should return some value' do
      expect {
        subject.const_name = 'AppSettings'
      }.to change(subject, :const_name).to('AppSettings')
    end

    it 'should return some value' do
      expect {
        subject.const_name = :'AppSettings'
      }.to change(subject, :const_name).to('AppSettings')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.const_name = -> {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.const_name = {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.const_name = [] }.to raise_error
      end
    end
  end

  describe '#root' do
    its(:root) do
      should eql(Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))))
    end
  end
end