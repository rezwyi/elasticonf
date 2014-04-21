require 'spec_helper'

describe ElastiConf do
  it { should be_a(Module) }

  describe '#configure' do
    before do
      subject.configure do |config|
        config.config_root = '/config'
        config.config_file = 'application'
        config.const_name = 'AppSettings'
      end
    end

    its(:config_root) { should eql(Pathname('/config')) }
    its(:config_file) { should eql('application') }
    its(:const_name) { should eql('AppSettings') }
  end

  describe '#reset_config!' do
    before { subject.reset_config! }

    its(:config_file) { should eql('config') }
    its(:const_name) { should eql('Settings') }

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

  describe '#config_file' do
    its(:config_file) { should eql('config') }

    it 'should return some value' do
      subject.config_file = 'application'
      subject.config_file.should eql('application')
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

  describe '#root' do
    its(:root) do
      should eql(Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))))
    end
  end

  describe '#load!' do
    before do
      subject.configure do |config|
        config.config_root = ElastiConf.root.join('spec', 'fixtures')
        config.config_file = 'application'
        config.const_name = 'AppSettings'
      end
    end

    it 'should not raise an error' do
      expect { subject.load! }.not_to raise_error
    end

    it 'should load some configuration' do
      subject.load!
      expect(AppSettings.some_config.int_key).to eql(1)
    end

    it 'should load some configuration' do
      subject.load!
      expect(AppSettings.some_config.str_key).to eql('1')
    end

    context 'when some env given' do
      let(:env) { :test }
      
      it 'should not raise an error' do
        expect { subject.load!(env) }.not_to raise_error
      end

      it 'should load some configuration' do
        subject.load! env
        expect(AppSettings.some_config.int_key).to eql(2)
      end

      it 'should load some configuration' do
        subject.load! env
        expect(AppSettings.some_config.str_key).to eql('2')
      end
    end
  end
end