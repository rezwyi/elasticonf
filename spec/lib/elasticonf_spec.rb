require 'spec_helper'

describe Elasticonf do
  it { should be_a(Module) }

  describe '#root' do
    its(:root) do
      should eql(Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))))
    end
  end

  describe '#config' do
    it 'should instantiate ElastiConf::Config' do
      expect(subject.config.class).to eql(Elasticonf::Config)
    end
  end

  describe '#configure' do
    before do
      subject.configure do |config|
        config.config_root = '/config'
        config.config_file = 'application'
        config.const_name = 'AppSettings'
        config.raise_if_already_initialized_constant = false
      end
    end

    it 'should return config_root' do
      expect(subject.config.config_root).to eql(Pathname('/config'))
    end

    it 'should return config_file' do
      expect(subject.config.config_file).to eql('application')
    end

    it 'should return const_name' do
      expect(subject.config.const_name).to eql('AppSettings')
    end

    it 'should return false' do
      expect(subject.config.raise_if_already_initialized_constant).to eql(false)
    end
  end

  describe '#load!' do
    before do
      subject.configure do |config|
        config.config_root = subject.root.join('spec', 'fixtures')
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

    context 'when some env given (as argument)' do
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

    context 'and some env given (through config.env)' do
      before { subject.config.env = :test }

      it 'should not raise an error' do
        expect { subject.load! }.not_to raise_error
      end

      it 'should load missing values from config file' do
        subject.load!
        expect(AppSettings.some_config.int_key).to eql(2)
      end

      it 'should override values from config file' do
        subject.load!
        expect(AppSettings.some_config.str_key).to eql('2')
      end
    end

    context 'when already initialized constant' do
      before { Kernel.const_set(const_name, {}) }
      
      it 'should raise an error' do
        expect { subject.load! }.to raise_error
      end

      it 'should not raise an error' do
        subject.config.raise_if_already_initialized_constant = false
        expect { subject.load! }.not_to raise_error
      end
    end

    context 'when .local file present' do
      let(:config_file) { subject.config.config_root.join('application.yml') }
      let(:local_config_file) { subject.config.config_root.join('application.local.yml') }
      
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

      context 'and some env given (as argument)' do
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

      context 'and some env given (through config.env)' do
        before { subject.config.env = :test }

        it 'should not raise an error' do
          expect { subject.load! }.not_to raise_error
        end

        it 'should load missing values from config file' do
          subject.load!
          expect(AppSettings.some_config.int_key).to eql(2)
        end

        it 'should override values from config file' do
          subject.load!
          expect(AppSettings.some_config.str_key).to eql('local')
        end
      end
    end
  end

  describe '#configure_and_load!' do
    before { Elasticonf.stub(:load!).and_return(true) }
    
    let(:config_block) do
      Proc.new do |config|
        config.config_root = subject.root.join('spec', 'fixtures')
        config.raise_if_already_initialized_constant = false
      end
    end
    
    it 'should call configure' do
      subject.should_receive :configure
      subject.configure_and_load! &config_block
    end

    it 'should call load' do
      subject.should_receive :load!
      subject.configure_and_load! &config_block
    end
  end
end