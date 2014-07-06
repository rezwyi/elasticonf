require 'spec_helper'

describe ElastiConf::Config do
  describe '#reset_config!' do
    before do
      subject.config_root = '/configuration'
      subject.config_file = 'application'
      subject.const_name = 'AppSettings'
      subject.raise_if_already_initialized_constant = false
      
      subject.reset_config!
    end

    its(:config_file) { should eql('config') }
    its(:const_name) { should eql('Settings') }
    its(:raise_if_already_initialized_constant) { should be_true }

    it 'should raise an error' do
      expect { subject.config_root }.to raise_error
    end
  end

  describe '#config_root' do
    it 'should raise an error' do
      expect { subject.config_root }.to raise_error
    end

    it 'should return some value' do
      subject.config_root = '/config'
      expect(subject.config_root).to eql(Pathname.new('/config'))
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

  describe '#config_file' do
    its(:config_file) { should eql('config') }

    it 'should return some value' do
      expect {
        subject.config_file = 'application'
      }.to change(subject, :config_file).to('application')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.config_file = -> {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.config_file = {} }.to raise_error
      end

      it 'should raise an error' do
        expect { subject.config_file = [] }.to raise_error
      end
    end
  end

  describe '#const_name' do
    its(:const_name) { should eql('Settings') }

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

  describe '#raise_if_already_initialized_constant' do
    its(:raise_if_already_initialized_constant) { should be_true }

    it 'should change to false' do
      expect {
        subject.raise_if_already_initialized_constant = false
      }.to change(subject, :raise_if_already_initialized_constant).to(false)
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = 'some_string'
        }.to raise_error
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = :some_symbol
        }.to raise_error
      end
      
      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = -> {}
        }.to raise_error
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = {}
        }.to raise_error
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = []
        }.to raise_error
      end
    end
  end
end