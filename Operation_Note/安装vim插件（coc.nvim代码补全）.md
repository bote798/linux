

## 安装vim插件（coc.nvim代码补全）

1. 安装node.js和npm(版本最好高一点)

   最好再找个安装教程看一下环境变量配置

   ```bash
   sudo apt install nodejs
   sudo apt install npm
   # 设置一下环境变量
   curl -sL install-node.now.sh/lts | bash
   ```

3. 安装vim－plug（插件管理器）

   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   
   mkdir -p  ~/.vim/autoload/
   cp plug.vim  ~/.vim/autoload/plug.vim
   ```

4. .vimrc文件有的系统有，有的没有，没有就自己建一个。这是系统的vim配置文件，home中的是用户的vim配置文件

   ```bash
   vim ~/.vimrc
   ```

   将这些复制到vimrc中

   ```bash
   call plug#begin()
   " The default plugin directory will be as follows:
   "   - Vim (Linux/macOS): '~/.vim/plugged'
   "   - Vim (Windows): '~/vimfiles/plugged'
   "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
   " You can specify a custom plugin directory by passing it as the argument
   "   - e.g. `call plug#begin('~/.vim/plugged')`
   "   - Avoid using standard Vim directory names like 'plugin'
   " Make sure you use single quotes
    
   " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
   Plug 'junegunn/vim-easy-align'
   " Any valid git URL is allowed
   Plug 'https://github.com/junegunn/vim-github-dashboard.git'
    
   " Multiple Plug commands can be written in a single line using | separators
   Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
   " On-demand loading
   Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
   Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
    
   " Using a non-default branch
   Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
   " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
   Plug 'fatih/vim-go', { 'tag': '*' }
    
   " Plugin options
   Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
   " Plugin outside ~/.vim/plugged with post-update hook
   Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    
   " Unmanaged plugin (manually installed and updated)
   Plug '~/my-prototype-plugin'
   " Initialize plugin system
   " - Automatically executes `filetype plugin indent on` and `syntax enable`.
   call plug#end()
   " You can revert the settings after the call like so:
   "   filetype indent off   " Disable file-type-specific indentation
   "   syntax off            " Disable syntax highlighting
   ```

   

5. 每一次在.vimrc文件中加入插件配置后，保存退出执行插件安装命令
   PlugInstall

   ```vim
   下载插件                             :PlugInstall
   
   下载新的插件                在call plug#begin()和call plug#end()之间添加一下新的插件
   
   安装特定插件                          :PlugInstall gist-vim
   
   卸载插件                             :PlugClean
   
   更新vim-plug                        :PlugUpgrade
   
   更新所有已经安装的插件         		:PlugUpdate
   
   查看插件状态                         :PlugStatus
   ```

   

6. 加入coc.nvim配置，执行安装命令，在nvim中执行检查命令检查状态

   ```vim
   # 在Plug#begin() 和 Plug#end()中间加这个
   Plug 'neoclide/coc.nvim', {'branch': 'release'}
   ```

7. 配置python补全servers

   相关网址: [Language servers · neoclide/coc.nvim Wiki · GitHub](https://github.com/neoclide/coc.nvim/wiki/Language-servers#python)

   ```bash
   pip3 install 'python-language-server[all]'
   vim ~/.vimrc
   :CocInstall coc-pyright
   ```

   

   **记得安装一下cmake吧，之后安装总用**

    退回主目录，输入：

   ```bash
   sudo apt install cmake
   sudo apt-get install cmake-qt-gui
   ```
