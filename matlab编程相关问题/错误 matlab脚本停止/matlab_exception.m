% 在执行脚本文件过程中可以让脚本暂停；
% 暂停，等待用户按下任意键继续
% pause(n); %暂停n秒，然后继续。
% pause; 

% input()也可以让脚本暂停，等待用户输入后继续执行脚本；
reply = input('Do you want more? Y/N [Y]:','s');

if isempty(reply)
  reply = 'Y';
end
       
%两者用法相似，不过error会终止程序，warning并不会。
error('输入不符合要求');
warning('输入不符合要求');

% quit和exit的功能是一样的，都是退出matlab，注意与error的区别，
% error只是退出执行脚本，而quit和exit直接推出了matlab程序。