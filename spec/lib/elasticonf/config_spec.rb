require 'spec_helper'

describe Elasticonf::Config do
  describe '#reset_config!' do
    before do
      subject.env = :test
      subject.config_root = '/configuration'
      subject.config_file = 'application'
      subject.const_name = 'AppSettings'
      subject.raise_if_already_initialized_constant = false

      subject.reset_config!
    end

    it 'should return default values' do
      expect(subject.env).to eql('development')
      expect(subject.config_file).to eql('settings')
      expect(subject.const_name).to eql('Settings')
      expect(subject.const_name).to eql('Settings')
      expect(subject.raise_if_already_initialized_constant).to be_truthy
    end

    it 'should raise an error' do
      expect { subject.config_root }.to raise_error(ArgumentError)
    end
  end

  describe '#env' do
    it 'should return default value' do
      expect(subject.env).to eql('development')
    end

    it 'should set new env' do
      expect { subject.env = :test }.to change(subject, :env).to('test')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.env = -> {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.env = {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.env = [] }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#config_root' do
    it 'should raise an error' do
      expect { subject.config_root }.to raise_error(ArgumentError)
    end

    it 'should set new config_root value' do
      subject.config_root = '/config'
      expect(subject.config_root).to eql(Pathname.new('/config'))
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.config_root = -> {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.config_root = {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.config_root = [] }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#config_file' do
    it 'should return default value' do
      expect(subject.config_file).to eql('settings')
    end

    it 'should set new config_file value' do
      expect {
        subject.config_file = 'application'
      }.to change(subject, :config_file).to('application')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.config_file = -> {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.config_file = {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.config_file = [] }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#const_name' do
    it 'should return default value' do
      expect(subject.const_name).to eql('Settings')
    end

    it 'should set new const_name value' do
      expect {
        subject.const_name = 'AppSettings'
      }.to change(subject, :const_name).to('AppSettings')
    end

    it 'should set new const_name value' do
      expect {
        subject.const_name = :'AppSettings'
      }.to change(subject, :const_name).to('AppSettings')
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect { subject.const_name = -> {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.const_name = {} }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect { subject.const_name = [] }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#raise_if_already_initialized_constant' do
    it 'should return default value' do
      expect(subject.raise_if_already_initialized_constant).to be_truthy
    end

    it 'should change raise_if_already_initialized_constant to false' do
      expect {
        subject.raise_if_already_initialized_constant = false
      }.to change(subject, :raise_if_already_initialized_constant).to(false)
    end

    context 'when wrong argument given' do
      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = 'some_string'
        }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = :some_symbol
        }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = -> {}
        }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = {}
        }.to raise_error(ArgumentError)
      end

      it 'should raise an error' do
        expect {
          subject.raise_if_already_initialized_constant = []
        }.to raise_error(ArgumentError)
      end
    end
  end
end
