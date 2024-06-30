# code-compare

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity
$ echo "# code-compare" >> README.md
git branch -M main
git remote add origin https://github.com/shiningdai/code-compare.git
git push -u origin main
daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity
$ git init
Initialized empty Git repository in D:/Daisurong/WorkSpace/projects/detect-code-changes/solidity/.git/

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (master)
$ git add README.md
warning: LF will be replaced by CRLF in README.md.
The file will have its original line endings in your working directory

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (master)
$ git commit -m "first commit"
[master (root-commit) 560303b] first commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (master)
$ git branch -M main

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git remote add origin https://github.com/shiningdai/code-compare.git

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git push -u origin main
fatal: unable to access 'https://github.com/shiningdai/code-compare.git/': Failed to connect to github.com port 443: Timed out

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git config --global --unset http.proxy

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git config --global --unset https.proxy

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git push -u origin main
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 232 bytes | 232.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/shiningdai/code-compare.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.


# branch origin

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git add --all
daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git commit -m "solidity original sourcecode"

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git push
Enumerating objects: 9712, done.
Counting objects: 100% (9712/9712), done.
Delta compression using up to 8 threads
Compressing objects: 100% (8123/8123), done.
Writing objects: 100% (9710/9710), 4.20 MiB | 4.34 MiB/s, done.
Total 9710 (delta 1401), reused 9710 (delta 1401), pack-reused 0
remote: Resolving deltas: 100% (1401/1401), done.
To https://github.com/shiningdai/code-compare.git
   560303b..947b53a  main -> main


# branch solcplus-v1

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ ls
CMakeLists.txt      CODING_STYLE.md  Changelog.md  README-bak.md  ReleaseChecklist.md  cmake/       docs/       liblangutil/  libsolc/      libsolutil/  scripts/  solc/  tools/
CODE_OF_CONDUCT.md  CONTRIBUTING.md  LICENSE.txt   README.md      SECURITY.md          codecov.yml  libevmasm/  libsmtutil/   libsolidity/  libyul/      snap/     test/

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (main)
$ git checkout -b solcplus-v1
Switched to a new branch 'solcplus-v1'

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git branch
  main
* solcplus-v1

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git push
fatal: The current branch solcplus-v1 has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin solcplus-v1


daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git push --set-upstream origin solcplus-v1
fatal: unable to access 'https://github.com/shiningdai/code-compare.git/': OpenSSL SSL_read: Connection was reset, errno 10054

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git push --set-upstream origin solcplus-v1
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: Create a pull request for 'solcplus-v1' on GitHub by visiting:
remote:      https://github.com/shiningdai/code-compare/pull/new/solcplus-v1
remote:
To https://github.com/shiningdai/code-compare.git
 * [new branch]      solcplus-v1 -> solcplus-v1
Branch 'solcplus-v1' set up to track remote branch 'solcplus-v1' from 'origin'.

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git add --all
daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git commit -m "upload solcplus-v1"
[solcplus-v1 5b349d5] upload solcplus-v1
 36 files changed, 2661 insertions(+), 17 deletions(-)
 create mode 100644 libsolidity/codegen/BufferContextHelper.cpp
 create mode 100644 libsolidity/codegen/BufferContextHelper.h
 create mode 100644 test/mTestCase/20230327debug.log
 create mode 100644 test/mTestCase/20230409debug.log
 create mode 100644 test/mTestCase/dex-demo.sol
 create mode 100644 test/mTestCase/expr_comp.log
 create mode 100644 test/mTestCase/lenet5-demo.sol
 create mode 100644 test/mTestCase/pack128.sol
 create mode 100644 test/mTestCase/smdlog.md
 create mode 100644 test/mTestCase/supplyChain.sol
 create mode 100644 test/mTestCase/unpack.sol
 create mode 100644 test/mTestCase/unpack_meaningful.sol

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)
$ git push
Enumerating objects: 86, done.
Counting objects: 100% (86/86), done.
Delta compression using up to 8 threads
Compressing objects: 100% (49/49), done.
Writing objects: 100% (50/50), 33.47 KiB | 2.57 MiB/s, done.
Total 50 (delta 37), reused 1 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (37/37), completed with 34 local objects.
To https://github.com/shiningdai/code-compare.git
   947b53a..5b349d5  solcplus-v1 -> solcplus-v1

daisu@Daisurong MINGW64 /d/Daisurong/WorkSpace/projects/detect-code-changes/solidity (solcplus-v1)


# 修改远程仓库名字
code-compare  ->  SolcPlus  

# 成功编译project，并编译示例合约

## 编译solcplus
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus/build$ make clean
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus/build$ cmake .. -DUSE_CVC4=OFF -DUSE_Z3=OFF

## 编译合约
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus/build/solc$ ./solc ./mTestCase/baseSample/sc1-baseSample.sol --asm --abi --opcodes --bin --storage-layout -o ./mTestCase/baseSample/output/
Warning: This is a pre-release compiler version, please do not use it in production.

Warning: SPDX license identifier not provided in source file. Before publishing, consider adding a comment containing "SPDX-License-Identifier: <SPDX-License>" to each source file. Use "SPDX-License-Identifier: UNLICENSED" for non-open-source code. Please see https://spdx.org for more information.
--> mTestCase/baseSample/sc1-baseSample.sol

Refusing to overwrite existing file "./mTestCase/baseSample/output/BaseSample.evm" (use --overwrite to force).


dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus$ git add --all
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus$ git commit -m"successfully compiled solidity contracts"
[solcplus-v1 9bcb7d4] successfully compiled solidity contracts
 7 files changed, 69 insertions(+), 5 deletions(-)
 rename test/mTestCase/{ => logs}/20230327debug.log (100%)
 rename test/mTestCase/{ => logs}/20230409debug.log (100%)
 create mode 100644 test/mTestCase/logs/cmd_record.md
 rename test/mTestCase/{ => logs}/expr_comp.log (100%)
 rename test/mTestCase/{ => logs}/smdlog.md (100%)
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus$ git push
枚举对象中: 17, 完成.
对象计数中: 100% (17/17), 完成.
使用 40 个线程进行压缩
压缩对象中: 100% (10/10), 完成.
写入对象中: 100% (10/10), 2.03 KiB | 2.03 MiB/s, 完成.
总共 10 （差异 7），复用 0 （差异 0）
remote: Resolving deltas: 100% (7/7), completed with 7 local objects.
To https://github.com/shiningdai/SolcPlus.git
   5b349d5..9bcb7d4  solcplus-v1 -> solcplus-v1
dsr@dell-PowerEdge-R740:~/myProjects/compilers/SolcPlus$
