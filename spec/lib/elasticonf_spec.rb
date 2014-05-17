require 'spec_helper'

describe ElastiConf do
  it { should be_a(Module) }

  describe '#configure' do
    before do
      subject.configure do |config|
        config.config_root = '/config'
        config.config_file = 'application'
        config.const_name = 'AppSettings'
        config.raise_if_already_initialized_constant = false
      end
    end

    its(:config_root) { should eql(Pathname('/config')) }
    its(:config_file) { should eql('application') }
    its(:const_name) { should eql('AppSettings') }
    its(:raise_if_already_initialized_constant) { should be_false }
  end

  describe '#reset_config!' do
    before { subject.reset_config! }

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
        config.const_name = const_name
      end
    end

    after do
      Kernel.send :remove_const, const_name
    end

    let(:const_name) { 'AppSettings' }

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

    context 'when already initialized constant' do
      before { Kernel.const_set(const_name, {}) }
      
      it 'should raise an error' do
        expect { subject.load! }.to raise_error
      end

      it 'should not raise an error' do
        subject.raise_if_already_initialized_constant = false
        expect { subject.load! }.not_to raise_error
      end
    end

    context 'when .local file present' do
      let(:config_file) { subject.config_root.join('application.yml') }
      let(:local_config_file) { subject.config_root.join('application.local.yml') }
      
      before do
        YAML::load_file(config_file).tap do |config|
          config['some_config']['str_key'] = 'local'
          config['some_config'].delete('int_key')
          File.open(local_config_file, 'w') { |f| f.write config.to_yaml }
        end
      end

      after { FileUtils.rm(local_config_file) }

      it 'should not raise an error' do
        expect { subject.load! }.not_to raise_error
      end

      it 'should load missing values from config file' do
        subject.load!
        expect(AppSettings.some_config.int_key).to eql(1)
      end
      
      it 'should override values from config file' do
        subject.load!
        expect(AppSettings.some_config.str_key).to eql('local')
      end

      context 'and some env given' do
        let(:env) { :test }

        it 'should not raise an error' do
          expect { subject.load!(env) }.not_to raise_error
        end

        it 'should load missing values from config file' do
          subject.load! env
          expect(AppSettings.some_config.int_key).to eql(2)
        end

        it 'should override values from config file' do
          subject.load! env
          expect(AppSettings.some_config.str_key).to eql('local')
        end
      end
    end
  end
end