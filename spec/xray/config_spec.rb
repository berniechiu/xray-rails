require 'spec_helper'

describe Xray::Config do
  context 'default_editor' do
    before do
      Xray.config.stub(:local_config).and_return({})
    end

    it 'should default to /usr/local/bin/subl' do
      ENV.stub(:[])
      expect(Xray.config.editor).to eq('/usr/local/bin/subl')
    end

    it 'should use $GEM_EDITOR over $VISUAL and $EDITOR' do
      ENV['GEM_EDITOR'] = 'vim'
      ENV['VISUAL'] = 'emacs'
      ENV['EDITOR'] = 'emacs'
      expect(Xray.config.editor).to eq('vim')
    end

    it 'should use $VISUAL over $EDITOR' do
      ENV['GEM_EDITOR'] = nil
      ENV['VISUAL'] = 'vim'
      ENV['EDITOR'] = 'emacs'
      expect(Xray.config.editor).to eq('vim')
    end

    it 'should use $HOME/.xrayconfig over env variables' do
      ENV['GEM_EDITOR'] = 'vim'
      Xray.config.stub(:local_config).and_return(editor: 'emacs')
      expect(Xray.config.editor).to eq('emacs')
    end
  end

  context ".config_file" do
    it "should use $HOME/.xrayconfig as default config file" do
      Dir.stub(:home).and_return('/home')
      expect(Xray.config.config_file).to eq('/home/.xrayconfig')
    end

    it "should use $PROJECT/.xrayconfig if it exists" do
      File.stub(:exists?).and_return(true)
      Dir.stub(:pwd).and_return('/project')
      expect(Xray.config.config_file).to eq("/project/.xrayconfig")
    end
  end
end
